# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module InvoiceRuns
  class TeamsFee < FixedFee
    private

    def item_class_for(attrs)
      case attrs
      in { leagues: Array} then InvoiceRuns::TeamItem
      in { name: }
        case name
        when /grundbeitrag_elite/ then InvoiceRuns::VereinItem
        when /grundbeitrag_andere/ then InvoiceRuns::VereinReducedItem
        end
      end
    end
  end
end
