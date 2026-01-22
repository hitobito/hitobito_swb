# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
require "spec_helper"

describe Invoice::VereinReducedItem do
  let(:bc_bern) { groups(:bc_bern) }
  let(:bc_olten) { groups(:bc_olten) }
  let(:bc_thun) { groups(:bc_thun) }
  let(:recipient_groups) { Group.where(id: [bc_bern.id]) }
  let(:invoice) { Fabricate(:invoice, group: bc_bern) }
  let(:attrs) {
    {
      invoice:,
      account: "1234",
      cost_center: "5678",
      name: "invoice item",
      dynamic_cost_parameters: {
        unit_cost: 10.50,
        period_start_on: 1.month.ago,
        period_end_on: 1.month.from_now
      }
    }
  }

  subject(:item) { described_class.for_groups(recipient_groups, **attrs) }

  context "validation" do
    it "is valid" do
      expect(item).to be_valid
    end

    it "is invalid without period start" do
      item.dynamic_cost_parameters[:period_start_on] = nil
      expect(item).not_to be_valid
    end

    it "is valid without period end" do
      item.dynamic_cost_parameters[:period_end_on] = nil
      expect(item).to be_valid
    end

    it "is invalid with wrong unit_cost value" do
      item.dynamic_cost_parameters[:unit_cost] = "foobar"
      expect(item).not_to be_valid
    end

    it "is invalid with nil unit_cost" do
      item.dynamic_cost_parameters[:unit_cost] = nil
      expect(item).not_to be_valid
    end
  end

  describe "#count" do
    before { Group::Verein.where.not(id: [bc_bern.id]).delete_all }

    it "includes verein without team" do
      expect(item.count).to eq 1
    end

    it "ignores archived verein" do
      bc_bern.update_columns(archived_at: 2.years.ago)
      expect(item.count).to eq 0
    end

    it "ignores deleted verein" do
      bc_bern.update_columns(deleted_at: 2.years.ago)
      expect(item.count).to eq 0
    end

    it "counts verein only once even if it has multiple non top league teams" do
      Fabricate(:team, group: bc_bern, league: "Senioren")
      Fabricate(:team, group: bc_bern, league: "Junioren")
      expect(item.count).to eq 1
    end

    [
      "NL - 5. Liga",
      "Senioren",
      "Junioren",
      "Vereinigung"
    ].each do |league|
      it "includes verein with '#{league}' team" do
        Fabricate(:team, group: bc_bern, league: league)
        expect(item.count).to eq 1
      end

      it "excludes verein with '#{league}' team and top team" do
        Fabricate(:team, group: bc_bern, league: "NLA")
        expect(item.count).to eq 0
      end
    end
  end

  describe "#dynamic_cost" do
    before { Group::Verein.where.not(id: [bc_bern.id, bc_olten.id]).delete_all }

    let(:recipient_groups) { Group.where(id: [bc_bern.id, bc_olten.id]) }

    it "multiplies price and count" do
      expect(item.dynamic_cost).to eq(21.00)
    end
  end
end
