# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Roles::Players::Phases
  def active(role)
    phases = Settings.roles.phases.map do |key, phase_string|
      next if /enabled|upgrades/.match?(key)
      const_get(key.to_s.classify).new(role, phase_string)
    end.compact
    phases.find(&:active?)
  end

  module_function :active
end
