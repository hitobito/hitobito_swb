# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Swb::InvoiceRuns::FixedFee
  extend ActiveSupport::Concern

  module ClassMethods
    def for(key, layer_group_ids = nil)
      return super unless key.to_sym == :roles

      InvoiceRuns::RolesFee.new(key, layer_group_ids)
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

  def item_class_for(attrs) # rubocop:todo Metrics/CyclomaticComplexity
    case attrs
    in { roles: Array } then InvoiceRuns::RoleItem
    in { groups: Array } then InvoiceRuns::RegionItem
    in { leagues: Array} then InvoiceRuns::TeamItem
    in { key: }
      case key
      when /grundbeitrag_elite/ then InvoiceRuns::VereinItem
      when /grundbeitrag_andere/ then InvoiceRuns::VereinReducedItem
      end
    else fail "no item for #{attrs}"
    end
  end
end
