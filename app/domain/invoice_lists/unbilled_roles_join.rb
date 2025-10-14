# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module InvoiceLists::UnbilledRolesJoin
  def with_unbilled_roles(scope)
    scope
      .joins(unbilled_roles_join)
      .where(billed_models: {id: nil})
  end

  def unbilled_roles_join
    sql = <<~SQL
      LEFT JOIN billed_models
      ON billed_models.model_id = roles.id AND billed_models.model_type = :model_type
      AND billed_models.billing_period_id = :billing_period_id
    SQL
    Role.sanitize_sql_for_conditions([sql,
      model_id: "roles.id", model_type: Role.sti_name, billing_period_id: BillingPeriod.active.id])
  end
end
