# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class VereinSeeder
  attr_reader :parent_id, :name

  def initialize(parent_id:, name:)
    @parent_id = parent_id
    @name = name
  end

  def seed
    result = Group::Verein.seed_once(:name, parent_id:, name:)
    verein = result.first
    league_sample.each do |league|
      verein_prefix = name.gsub(/(BC|SC)\s/, "")
      team_name = [verein_prefix, league].join(" ")

      Team.seed_once(:name, group_id: verein.id, name: team_name, league: league, year: Time.zone.today.year)
    end
  end

  def league_sample
    Team::LEAGUES.cycle(rand(2..6)).to_a.sample(rand(1..10)).to_a
  end
end
