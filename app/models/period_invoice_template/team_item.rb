# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class PeriodInvoiceTemplate::TeamItem < PeriodInvoiceTemplate::Item
  validates :leagues, presence: true

  def leagues
    dynamic_cost_parameters[:leagues] || []
  end
end
