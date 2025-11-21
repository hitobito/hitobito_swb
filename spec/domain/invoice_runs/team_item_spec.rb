# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe InvoiceRuns::TeamItem do
  let(:attrs) { {fee: :teams, key: :nlab, unit_cost: 10, leagues: %W[NLA NLB], layer_group_ids:} }
  let(:bc_bern) { groups(:bc_bern) }
  let(:bc_olten) { groups(:bc_olten) }

  let(:layer_group_ids) { nil }

  subject(:item) { described_class.new(**attrs) }

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

    context "for layer" do
      let(:layer_group_ids) { [bc_bern.layer_group_id] }

      it "counts teams in bern" do
        Fabricate(:team, group: bc_bern, league: "NLA")
        Fabricate(:team, group: bc_bern, league: "NLB")
        expect(item.count).to eq 2
      end

      it "ignores teams in basel" do
        Fabricate(:team, group: bc_olten, league: "NLA")
        Fabricate(:team, group: bc_olten, league: "NLB")
        expect(item.count).to eq 0
      end
    end
  end
end
