# frozen_string_literal: true

#  Copyright (c) 2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Role::Player < ::Role
  validate :only_one_player_role_per_group

  private

  def only_one_player_role_per_group
    errors.add(:person, :already_player_in_group) if (person.roles.where(group:) - [self]).any?
  end
end
