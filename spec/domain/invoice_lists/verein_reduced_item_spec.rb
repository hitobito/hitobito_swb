# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
require "spec_helper"

describe InvoiceLists::VereinReducedItem do
  let(:attrs) { {fee: :teams, key: :grundbeitrag_andere, unit_cost: 10, layer_group_ids:} }
  let(:bc_bern) { groups(:bc_bern) }
  let(:bc_olten) { groups(:bc_olten) }

  let(:layer_group_ids) { nil }

  subject(:item) { described_class.new(**attrs) }

  describe "#count" do
    it "includes all if they have no team" do
      expect(item.count).to eq 6
    end

    context "single verein" do
      before { Group::Verein.where.not(id: [bc_bern.id]).delete_all }

      it "includes verein without team" do
        expect(item.count).to eq 1
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

    context "layer_group_ids" do
      let(:layer_group_ids) { [bc_bern.layer_group_id, bc_olten.layer_group_id] }

      it "filters by layer_group_id" do
        expect(item.count).to eq 2
      end
    end
  end
end
