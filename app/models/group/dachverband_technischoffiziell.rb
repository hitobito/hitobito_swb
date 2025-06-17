# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::DachverbandTechnischoffiziell < ::Group
  self.static_name = true

  ### ROLES

  class Linienrichter < ::Role
    self.permissions = [:group_read]
  end

  class Schiedsrichter < ::Role
    self.permissions = [:group_read]
  end

  class Referee < ::Role
    self.permissions = [:group_read]
  end

  roles Linienrichter, Referee, Schiedsrichter
end
