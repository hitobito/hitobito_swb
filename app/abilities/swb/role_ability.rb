# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::RoleAbility
  extend ActiveSupport::Concern

  prepended do
    on(Role) do
      general(:create).if_create_in_active_phase?
      general(:destroy).if_destroy_in_active_phase?
      general(:update).if_update_in_active_phase?
    end
  end

  def if_create_in_active_phase?
    !player? || admin? || active_phase.create?
  end

  def if_destroy_in_active_phase?
    !player? || admin? || active_phase.destroy?
  end

  def if_update_in_active_phase?
    !player? || admin? || active_phase.update?
  end

  private

  def player? = subject.is_a?(Role::Player)

  def admin? = user_context.admin

  def active_phase
    @active_phase ||= Roles::Players::Phases.active(subject)
  end
end
