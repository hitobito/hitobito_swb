# frozen_string_literal: true

#  Copyright (c) 2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe SwbImport::TeamsReplacement do
  let(:bern) { groups(:bc_bern) }
  let(:thun) { groups(:bc_thun) }
  let(:header) { "Clubnumber,Clubname,Teamname,Drawname,Eventname" }

  subject(:replacement) { described_class.new }

  before do
    bern.update_columns(ts_club_number: 11)
    thun.update_columns(ts_club_number: 22)
    if SwbImport::Parser.class_variable_defined?(:@@club_numbers)
      SwbImport::Parser.remove_class_variable(:@@club_numbers)
    end
    allow_any_instance_of(SwbImport::Csv).to receive(:csv)
      .and_return(CSV.parse([header, *rows].join("\n"), headers: true))
    allow($stdout).to receive(:puts)

    bern.teams.create!(name: "BC Bern 1", league: "2. Liga", year: 2025)
    bern.teams.create!(name: "BC Bern 2", league: "4. Liga", year: 2025)
  end

  context "with valid rows" do
    let(:rows) do
      [
        "11,BC Bern,BC Bern 1,,1. Liga",
        "11,BC Bern,BC Bern J,,Junioren",
        "22,BC Thun,BC Thun 1,,NLB"
      ]
    end

    it "replaces all existing teams with the imported ones" do
      replacement.run

      expect(Team.pluck(:group_id, :name, :league, :year)).to match_array [
        [bern.id, "BC Bern 1", "1. Liga", Time.zone.today.year],
        [bern.id, "BC Bern J", "Junioren", Time.zone.today.year],
        [thun.id, "BC Thun 1", "NLB", Time.zone.today.year]
      ]
    end
  end

  context "with a row of an unknown club number" do
    let(:rows) do
      [
        "11,BC Bern,BC Bern 1,,1. Liga",
        "99,BC Unbekannt,BC Unbekannt 1,,3. Liga"
      ]
    end

    it "keeps the existing teams" do
      expect { replacement.run }.to raise_error(/1 of 2 teams failed/)

      expect(Team.pluck(:name, :league)).to match_array [
        ["BC Bern 1", "2. Liga"],
        ["BC Bern 2", "4. Liga"]
      ]
    end
  end

  context "without any rows" do
    let(:rows) { [] }

    it "keeps the existing teams" do
      expect { replacement.run }.to raise_error(/No teams found/)

      expect(Team.count).to eq 2
    end
  end

  context "with an unknown league" do
    let(:rows) { ["11,BC Bern,BC Bern 1,,3. Liga - 2HD"] }

    it "keeps the existing teams" do
      expect { replacement.run }.to raise_error(/1 of 1 teams failed/)

      expect(Team.count).to eq 2
    end
  end
end
