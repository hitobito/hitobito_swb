# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::RegionKontakte < ::Group
  self.static_name = true

  ### ROLES

  class Kontakt < ::Role
  end

  class Medien < ::Role
  end

  class Partner < ::Role
  end

  class Ehrenmitglied < ::Role
  end

  class Volunteer < ::Role
  end

  roles Kontakt,
    Medien,
    Partner,
    Ehrenmitglied,
    Volunteer
end
