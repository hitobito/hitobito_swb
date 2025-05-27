# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::InvoiceLists::RoleItem
  extend ActiveSupport::Concern

  prepended do
    include InvoiceLists::UnbilledRolesJoin
  end

  def to_invoice_item
    InvoiceItem::Roles
      .new(name:, unit_cost:, count:, dynamic_cost_parameters: {fixed_fees: fee})
      .tap(&:recalculate)
      .tap { |item| item.roles = models }
  end

  protected

  def scope
    with_unbilled_roles(super)
  end
end
