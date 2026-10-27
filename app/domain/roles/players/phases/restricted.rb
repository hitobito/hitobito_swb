# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Roles::Players::Phases
  # During phase_3, nothing besides the creation of certain roles is allowed,
  # no upgrades/downgrades, no deletions. Only junior roles can be created
  class Restricted < Base
    # same_type? lets bulk assignment fail per person by validation instead of aborting
    def create? = checker.junior? && (checker.first_role? || checker.same_type? || checker.upgrade?)
  end
end
