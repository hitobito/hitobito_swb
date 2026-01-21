# frozen_string_literal: true

#  Copyright (c) 2012-2026, BdP and DPSG. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class Invoice::RegionItem < Invoice::PeriodItem
  def count
    @count ||= base_scope
      .active(period_start_on..period_end_on)
      .where(id: group_scope)
      .count
  end

  private

  def base_scope
    Group::Region.without_archived_or_deleted
  end
end
