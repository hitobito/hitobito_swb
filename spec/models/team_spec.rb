# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Team do
  it "is invalid without group" do
    team = Team.new(name: "Bern 1", league: "1. Liga", year: 2025)

    expect(team).not_to be_valid
    expect(team.errors.attribute_names).to eq [:group]
  end

  describe "::list" do
    let(:group) { groups(:bc_bern) }

    it "sorts name and number in name" do
      group.teams.create!(name: "Bern 1", league: "1. Liga", year: 2025)
      group.teams.create!(name: "Bern 2", league: "3. Liga", year: 2025)
      group.teams.create!(name: "Bern 10", league: "4. Liga", year: 2025)
      expect(group.teams.list.pluck(:name)).to eq ["Bern 1", "Bern 2", "Bern 10"]
    end
  end
end
