# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::RegionVorstand < ::Group
  self.static_name = true

  ### ROLES

  class Administrator < ::Role
    self.permissions = [:layer_and_below_full, :finance]
  end

  class Finanzen < ::Role
    self.permissions = [:layer_and_below_read, :finance]
  end

  class Praesident < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Vizepraesident < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Mitglied < ::Role
    self.permissions = [:layer_and_below_read]
  end

  roles Praesident, Vizepraesident, Administrator, Finanzen, Mitglied
end
