# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::Region < ::Group
  self.layer = true
  self.used_attributes += [:yearly_budget, :founded_on]
  children RegionVorstand,
    RegionSpieler,
    RegionKontakte,
    Verein

  self.default_children = [
    RegionVorstand,
    RegionSpieler,
    RegionKontakte
  ]

  self.event_types = [Event, Event::Course]

  ### ROLES

  class JSCoach < ::Role
    self.permissions = [:group_read]
  end

  class Interclub < ::Role
    self.permissions = [:layer_and_below_full]
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

  class Finanzen < ::Role
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

  roles JSCoach,
    Antidoping,
    Ausbildung,
    Breitensport,
    Clubmanagement,
    Ethik,
    EventTurnier,
    Finanzen,
    Interclub,
    Kommunikation,
    Leistungssport,
    Marketing,
    Medical,
    Nachwuchs,
    Personal,
    Umfeld
end
