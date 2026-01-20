# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Invoice::VereinReducedItem < VereinItem
  private

  def base_scope
    Group::Verein
      .without_archived_or_deleted
      .joins("LEFT JOIN teams ON teams.group_id = groups.id AND #{top_league_condition}")
  end

  def team_scope
    { league: nil }
  end

  def top_league_condition
    Team.sanitize_sql_for_conditions(["teams.league IN (?)", Team::TOP_LEAGUES])
  end
end
