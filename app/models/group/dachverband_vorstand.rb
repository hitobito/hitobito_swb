# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::DachverbandVorstand < ::Group
  self.static_name = true

  ### ROLES

  class Praesident < ::Role
    self.permissions = [:layer_full, :contact_data]
  end

  class Vizepraesident < ::Role
    self.permissions = [:layer_full, :contact_data]
  end

  class Mitglied < ::Role
    self.permissions = [:layer_full, :contact_data]
  end

  roles Praesident, Vizepraesident, Mitglied
end
