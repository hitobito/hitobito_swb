# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Invoice::RoleCountItem
  extend ActiveSupport::Concern

  prepended do
    include Invoices::UnbilledRolesJoin
  end

  protected

  def base_scope
    with_unbilled_roles(super)
  end
end
