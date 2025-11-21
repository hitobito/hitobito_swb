# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Roles::Players
  class MarkAsBilled
    def initialize(role)
      @role = role
    end

    def run
      if billable? && billed_model
        attrs = billed_model.attributes.slice("billing_period_id", "invoice_item_id")
        BilledModel.create!(attrs.merge(model: role))
      end
    end

    private

    attr_reader :role

    def role_types_with_costs
      @role_types_with_costs ||= InvoiceRuns::FixedFee.for(:roles).config.items
        .select { |item| item.unit_cost.positive? }
        .flat_map(&:roles)
    end

    def roles
      role.person.roles.with_inactive.where(type: role_types_with_costs)
    end

    def billable?
      role_types_with_costs.include?(role.type)
    end

    def billed_model
      return @billed_model if defined?(@billed_model)

      @billed_model = BilledModel
        # rubocop:todo Layout/LineLength
        .find_by(billing_period: BillingPeriod.active, model_type: "Role", model_id: roles.map(&:id))
      # rubocop:enable Layout/LineLength
    end
  end
end
