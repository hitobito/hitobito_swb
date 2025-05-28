# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::InvoiceListsController
  extend ActiveSupport::Concern

  def cancel_all_invoices
    invoice_item_ids = invoices.flat_map { |i| i.invoice_items.map(&:id) }
    super
    BilledModel.where(invoice_item_id: invoice_item_ids).delete_all
  end
end
