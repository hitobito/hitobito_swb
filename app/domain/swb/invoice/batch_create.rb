# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Invoice::BatchCreate
  extend ActiveSupport::Concern

  def invoice_items_attributes(recipient)
    invoice.invoice_items.collect do |item|
      item.calculate_amount(recipient:)
      attrs = item.attributes
      # Do not try to save invalid item since that would abort the whole invoice create transaction
      attrs if InvoiceItem.new(attrs).recalculate.valid?
    end.compact
  end
end
