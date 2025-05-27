# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

Fabricator(:team) do
  group
  name { |attrs| [Faker::Team.name, attrs[:league]].join(" - ") }
  year { Time.zone.today.year }
  league { Team::LEAGUES.sample }
end

Fabricator(:top_team, extends: :team) do
  league { Team::TOP_LEAGUES.sample }
end
