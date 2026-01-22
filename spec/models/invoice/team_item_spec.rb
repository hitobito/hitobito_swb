# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Invoice::TeamItem do
  let(:bc_bern) { groups(:bc_bern) }
  let(:bc_olten) { groups(:bc_olten) }
  let(:recipient_groups) { Group.where(id: [bc_bern.id, bc_olten.id]) }
  let(:invoice) { Fabricate(:invoice, group: bc_bern) }
  let(:attrs) {
    {
      invoice:,
      account: "1234",
      cost_center: "5678",
      name: "invoice item",
      dynamic_cost_parameters: {
        unit_cost: 10.50,
        leagues: %W[NLA NLB],
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

    it "is invalid without leagues" do
      item.dynamic_cost_parameters[:leagues] = nil
      expect(item).not_to be_valid
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
    it "is 0 without any teams" do
      expect(item.count).to eq 0
    end

    it "is 0 with non configured teams" do
      Fabricate(:team, group: bc_bern, league: "1. Liga")
      expect(item.count).to eq 0
    end

    it "sums teams matching leagues" do
      Fabricate(:team, group: bc_bern, league: "NLA")
      Fabricate(:team, group: bc_olten, league: "NLB")
      2.times { Fabricate(:team, group: bc_bern, league: "NLB") }
      expect(item.count).to eq 4
    end

    it "returns amount of teams for that league across all layers" do
      Fabricate(:team, group: bc_bern, league: "NLA")
      Fabricate(:team, group: bc_olten, league: "NLB")
      expect(item.count).to eq 2
    end

    it "ignores archived groups" do
      bc_bern.update_columns(archived_at: 2.years.ago)
      Fabricate(:team, group: bc_bern, league: "NLA")
      Fabricate(:team, group: bc_olten, league: "NLB")
      expect(item.count).to eq 1
    end

    it "ignores deleted groups" do
      bc_bern.update_columns(deleted_at: 2.years.ago)
      Fabricate(:team, group: bc_bern, league: "NLA")
      Fabricate(:team, group: bc_olten, league: "NLB")
      expect(item.count).to eq 1
    end

    context "for layer" do
      subject(:item) { described_class.for_groups(bc_bern, **attrs) }

      it "counts teams in bern" do
        Fabricate(:team, group: bc_bern, league: "NLA")
        Fabricate(:team, group: bc_bern, league: "NLB")
        expect(item.count).to eq 2
      end

      it "ignores teams in olten" do
        Fabricate(:team, group: bc_olten, league: "NLA")
        Fabricate(:team, group: bc_olten, league: "NLB")
        expect(item.count).to eq 0
      end
    end
  end

  describe "#dynamic_cost" do
    it "multiplies price and count" do
      Fabricate(:team, group: bc_bern, league: "NLA")
      Fabricate(:team, group: bc_olten, league: "NLB")
      expect(item.dynamic_cost).to eq(21.00)
    end
  end
end
