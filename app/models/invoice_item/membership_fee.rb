# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class InvoiceItem::MembershipFee < InvoiceItem
  # NOTE: Needed to persist model, should be translated, not sure where this is done in SBV
  attribute :name, :string, default: "MembershipFee"

  # Would be much better than recipient_id in order to identify roles for dynamic cost
  attr_accessor :verein_id

  AMOUNT = 10

  def dynamic_cost
    return 10
    Group::VereinSpieler.where(layer_group_id: verein_id).people.count * AMOUNT if verein_id
  end
end
