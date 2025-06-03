# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Swb::InvoiceLists::FixedFees
  extend ActiveSupport::Concern

  module ClassMethods
    def for(key, layer_group_ids = nil)
      return super unless key.to_sym == :roles

      InvoiceLists::RolesFee.new(key, layer_group_ids)
    end
  end

  def invoice_items
    items.map do |item|
      item.to_invoice_item.tap do |invoice_item|
        invoice_item.account = config.account
        invoice_item.cost_center = config.cost_center
      end
    end
  end

  private

  def item_class_for(attrs)
    case attrs
    in { roles: Array } then InvoiceLists::RoleItem
    in { groups: Array } then InvoiceLists::RegionItem
    in { leagues: Array} then InvoiceLists::TeamItem
    in { key: }
      case key
      when /grundbeitrag_elite/ then InvoiceLists::VereinItem
      when /grundbeitrag_andere/ then InvoiceLists::VereinReducedItem
      end
    else fail "no item for #{attrs}"
    end
  end
end
