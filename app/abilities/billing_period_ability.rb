# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class BillingPeriodAbility < AbilityDsl::Base
  on(BillingPeriod) do
    class_side(:index).if_admin

    permission(:admin).may(:manage).all
  end
end
