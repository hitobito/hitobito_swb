# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module InvoiceLists
  class TeamItem < Item
    def initialize(fee:, key:, unit_cost:, leagues:, layer_group_ids: nil)
      super(fee:, key:, unit_cost:, layer_group_ids:)
      @leagues = leagues
    end

    private

    def scope = Group::Verein
      .joins(:teams)
      .where(teams: {league: @leagues})
  end
end
