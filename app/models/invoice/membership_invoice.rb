# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Invoice::MembershipInvoice < Invoice
  def groups
    Groups::Verein.all
  end

  def people
    Group::Verein::Finanzen.distinct_on("group_id").pluck(:person_id)
  end
end
