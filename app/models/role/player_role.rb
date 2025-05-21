# frozen_string_literal: true

#  Copyright (c) 2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Role::PlayerRole < ::Role
  validate :only_one_player_role_per_group

  private

  def only_one_player_role_per_group
    errors.add(:person, I18n.t("activerecord.errors.models.role.already_player_in_group")) if player_roles_in_group.any?
  end

  def player_roles_in_group
    person.roles.where(group: group).select do |role|
      role.class < Role::PlayerRole
    end
  end
end
