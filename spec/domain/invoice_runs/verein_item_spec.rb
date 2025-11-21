# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe InvoiceRuns::VereinItem do
  let(:attrs) { {fee: :teams, key: :grundbeitrag_elite, unit_cost: 10, layer_group_ids:} }
  let(:bc_bern) { groups(:bc_bern) }
  let(:bc_olten) { groups(:bc_olten) }

  let(:layer_group_ids) { nil }

  subject(:item) { described_class.new(**attrs) }

  describe "#count" do
    it "is 0 without any teams" do
      expect(item.count).to eq 0
    end

    it "returns 1 with multiple top teams" do
      Fabricate(:team, group: bc_bern, league: "NLA")
      2.times { Fabricate(:team, group: bc_bern, league: "1. Liga") }
      expect(item.count).to eq 1
    end

    it "returns 2 with multiple top teams" do
      Fabricate(:team, group: bc_bern, league: "NLA")
      Fabricate(:team, group: bc_olten, league: "NLA")
      expect(item.count).to eq 2
    end

    it "returns 1 with multiple top teams and a junior team" do
      Fabricate(:team, group: bc_bern, league: "NLA")
      Fabricate(:team, group: bc_bern, league: "1. Liga")
      Fabricate(:team, group: bc_bern, league: "Junioren")
      expect(item.count).to eq 1
    end

    it "returns 0 with only non top teams" do
      Fabricate(:team, group: bc_bern, league: "Senioren")
      Fabricate(:team, group: bc_bern, league: "Junioren")
      Fabricate(:team, group: bc_bern, league: "Vereinigung")
      expect(item.count).to eq 0
    end
  end
end
