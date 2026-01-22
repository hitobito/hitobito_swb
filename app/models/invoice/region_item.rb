# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Invoice::RegionItem < Invoice::PeriodItem
  private

  def base_scope
    Group::Region
  end

  def people_condition
    # Disable the people condition, this item cannot be used in an invoice addressed to a person
    Person.all
  end
end
