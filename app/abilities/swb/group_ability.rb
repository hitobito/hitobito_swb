# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::GroupAbility
  extend ActiveSupport::Concern

  prepended do
    on(Group) do
      permission(:any).may(:"index_event/tournaments").all
      permission(:any).may(:"index_event/external_trainings").all

      permission(:any)
        .may(:index_events, :index_mailing_lists)
        .if_player_in_hierarchy_or_any_role
      permission(:any)
        .may(:read)
        .if_player_in_hierarchy_or_root_or_any_role
    end

    def if_player_in_hierarchy_or_root_or_any_role
      if_player_in_hierarchy_or_any_role || subject.root?
    end

    def if_player_in_hierarchy_or_any_role
      return if_any_role unless user.roles.all? { |r| r.is_a?(Role::Player) }

      user.groups_hierarchy_ids[1..].include?(subject.layer_group_id)
    end
  end
end
