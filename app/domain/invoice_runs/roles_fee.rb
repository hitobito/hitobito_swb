# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module InvoiceRuns
  class RolesFee < FixedFee
    include InvoiceRuns::UnbilledRolesJoin

    def initialize(...)
      super
      @layer_group_ids ||= unbilled_layer_group_ids if billing_period_active?
    end

    def prepare(invoice_run)
      return super if BillingPeriod.active

      yield [:warning, t(".active_billing_period_required")] if block_given?
    end

    private

    def unbilled_layer_group_ids
      with_unbilled_roles(roles_scope)
        .pluck("DISTINCT(groups.layer_group_id)")
    end

    def roles_scope
      Role
        .joins(:group)
        .where(roles: {type: config.items.flat_map(&:roles)})
    end

    def billing_period_active?
      return @billing_period_active if defined?(@billing_period_active)

      @billing_period_active = BillingPeriod.active
    end
  end
end
