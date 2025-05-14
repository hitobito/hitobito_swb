# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::InvoiceListsController
  extend ActiveSupport::Concern

  # prepended do
  #   before_render_form :populate_membership_invoice
  # end
  #
  # def populate_membership_invoice
  #   return if params.key?(:invoice_list)
  #
  #   flash.now[:notice] = "Rechnung mit dynamischen Rechnungsposten"
  #   entry.invoice = Invoice::MembershipInvoice.new(group: parent)
  #   entry.invoice.invoice_items = [InvoiceItem::MembershipFee.new]
  #   entry.recipient_ids = Group::Verein::Finanzen.distinct_on("group_id").pluck(:person_id)
  # end
  #
  def permitted_params
    params.key?(:invoice_list) ? super : {}
  end

  def assign_attributes
    super
    entry.recipient_ids = Group::Verein::Finanzen.distinct_on("group_id").pluck(:person_id)
    entry.invoice.invoice_items = [
      InvoiceItem::MembershipFee::Senior.new,
      InvoiceItem::MembershipFee::Junior.new
    ]
  end
end
