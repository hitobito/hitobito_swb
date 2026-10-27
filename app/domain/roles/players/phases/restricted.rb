# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Roles::Players::Phases
  # During phase_3, only junior roles can be created or upgraded.
  # No downgrades, no deletions.
  class Restricted < Base
    # same_type? lets bulk assignment fail per person by validation instead of aborting
    def create? = checker.junior? && (checker.first_role? || checker.same_type? || checker.upgrade?)

    def update? = checker.junior? && checker.upgradeable?
  end
end
