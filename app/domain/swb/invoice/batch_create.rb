# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Invoice::BatchCreate
  extend ActiveSupport::Concern

  private

  def add_invoice_items(invoice, recipient)
    super.then do
      next unless invoice_run.fixed_fee

      invoice.recipient_address = [
        Group.find(recipient.layer_group_id).name,
        Person::Address.new(Person.find(recipient.id)).for_invoice
      ].join("\n")
    end
  end
end
