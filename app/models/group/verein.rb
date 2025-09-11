# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::Verein < ::Group
  self.layer = true
  self.used_attributes += [:yearly_budget, :founded_on, :ts_club_number]

  children VereinVorstand,
    VereinSpieler,
    VereinKontakte

  self.default_children = [
    VereinVorstand,
    VereinSpieler,
    VereinKontakte
  ]
  ### ROLES

  class JSCoach < ::Role
    self.permissions = [:group_read]
  end

  class Interclub < ::Role
    self.permissions = [:layer_full]
  end

  class EventTurnier < ::Role
    self.permissions = [:group_read]
  end

  class Ausbildung < ::Role
    self.permissions = [:group_read]
  end

  class Breitensport < ::Role
    self.permissions = [:group_read]
  end

  class Leistungssport < ::Role
    self.permissions = [:group_read]
  end

  class Nachwuchs < ::Role
    self.permissions = [:group_read]
  end

  class Ethik < ::Role
    self.permissions = [:group_read]
  end

  class Umfeld < ::Role
    self.permissions = [:group_read]
  end

  class Antidoping < ::Role
    self.permissions = [:group_read]
  end

  class Clubmanagement < ::Role
    self.permissions = [:group_read]
  end

  class Kommunikation < ::Role
    self.permissions = [:group_read]
  end

  class Marketing < ::Role
    self.permissions = [:group_read]
  end

  class Medical < ::Role
    self.permissions = [:group_read]
  end

  class Personal < ::Role
    self.permissions = [:group_read]
  end

  class Clubtrainer < ::Role
    self.permissions = [:group_read]
  end

  class Nationalliga < ::Role
    self.permissions = [:group_read]
  end

  class Schiedsrichter < ::Role
    self.permissions = [:group_read]
  end

  roles JSCoach,
    Schiedsrichter,
    Clubtrainer,
    Nationalliga,
    Antidoping,
    Ausbildung,
    Ethik,
    Breitensport,
    Clubmanagement,
    EventTurnier,
    Interclub,
    Kommunikation,
    Leistungssport,
    Marketing,
    Medical,
    Nachwuchs,
    Personal,
    Umfeld
end
