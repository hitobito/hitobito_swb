# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::RolesHelper
  def player_transfer_link(role)
    link_to(
      icon(:"people-arrows"),
      new_group_role_player_transfer_path(role.group, role),
      title: t("roles.player_transfer_title"),
      alt: t("roles.player_transfer_title")
    )
  end

  def player_transfer_possible?(role)
    can?(:update, role) &&
      role.is_a?(Role::Player) &&
      Roles::Players::Phases.active(role).is_a?(Roles::Players::Phases::Open) &&
      PlayerTransfer.new(role).accepted_targets.any?
  end
end
