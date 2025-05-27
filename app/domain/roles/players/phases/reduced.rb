# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Roles::Players::Phases
  # During this phase, it is still possible to create new roles.
  # Deleting old roles is not possible anymore, as well as downgrading roles.
  class Reduced < Base
    def create?
      checker.upgrade? || checker.new_and_only?
    end

    def update?
      checker.upgrade?
    end
  end
end
