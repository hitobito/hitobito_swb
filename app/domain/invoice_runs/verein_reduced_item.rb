# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module InvoiceRuns
  class VereinReducedItem < Item
    private

    def scope
      Group::Verein
        .joins("LEFT JOIN teams ON teams.group_id = groups.id AND #{top_league_condition}")
        .where(teams: {league: nil})
        .distinct
    end

    def top_league_condition
      Team.sanitize_sql_for_conditions(["teams.league IN (?)", Team::TOP_LEAGUES])
    end
  end
end
