# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Roles::Players::Phases
  # rubocop:todo Layout/LineLength
  # During phase_3, nothing besides the creation of certain roles is allowed, no upgrades/downgrades, no deletions
  # rubocop:enable Layout/LineLength
  # Only junior roles can be created
  class Restricted < Base
    def create?
      checker.new? && checker.junior?
    end
  end
end
