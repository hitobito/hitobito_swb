# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::RegionKontakte < ::Group
  ### ROLES

  class Adressverwaltung < ::Role
    self.permissions = [:group_and_below_full]
  end

  class Kontakt < ::Role
  end

  roles Adressverwaltung, Kontakt
end
