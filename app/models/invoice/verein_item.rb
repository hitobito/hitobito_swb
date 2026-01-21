# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Invoice::VereinItem < Invoice::PeriodItem
  def count
    @count ||= base_scope
      .active(period_start_on..period_end_on)
      .where(id: group_scope)
      .where(teams: team_scope)
      .distinct # this is a "Pauschale". Each Verein only pays once.
      .count
  end

  private

  def base_scope
    Group::Verein
      .without_archived_or_deleted
      .joins(:teams)
  end

  def team_scope
    {league: Team::TOP_LEAGUES}
  end
end
