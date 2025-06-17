# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::DachverbandKontakte < ::Group
  self.static_name = true

  ### ROLES

  class Kontakt < ::Role
  end

  class EhemaligesZvmitglied < ::Role
  end

  class EhemaligerMitarbeiter < ::Role
  end

  class Ehrenmitglied < ::Role
  end

  class ShuttletimeTutor < ::Role
  end

  class Goenner < ::Role
  end

  class Medien < ::Role
  end

  class Partner < ::Role
  end

  class JSExperte < ::Role
  end

  roles Kontakt,
    EhemaligesZvmitglied,
    EhemaligerMitarbeiter,
    Ehrenmitglied,
    ShuttletimeTutor,
    Goenner,
    Medien,
    Partner,
    JSExperte
end
