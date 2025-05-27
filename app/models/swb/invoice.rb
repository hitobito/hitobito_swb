# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Invoice
  extend ActiveSupport::Concern

  prepended do
    after_update :delete_billed_models, if: -> { cancelled? }
  end

  private

  def delete_billed_models
    BilledModel.where(invoice_item_id: invoice_items.map(&:id)).delete_all
  end
end
