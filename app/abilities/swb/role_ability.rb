# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::RoleAbility
  extend ActiveSupport::Concern

  prepended do
    on(Role) do
      general(:create).if_create_in_current_phase?
      general(:destroy).if_destroy_in_current_phase?
      general(:update).if_update_in_current_phase?
    end
  end

  def if_create_in_current_phase?
    phase_checker.create?
  end

  def if_destroy_in_current_phase?
    phase_checker.destroy?
  end

  def if_update_in_current_phase?
    phase_checker.update?
  end

  private

  def phase_checker
    @phase_checker ||= Roles::Players::Phase.for(subject)
  end
end
