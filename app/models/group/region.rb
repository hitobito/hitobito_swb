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

  class ChefAusbildung < ::Role
    self.permissions = [:group_read]
  end

  class ChefBreitensport < ::Role
    self.permissions = [:group_read]
  end

  class ChefLeistungssport < ::Role
    self.permissions = [:group_read]
  end

  class ChefNachwuchs < ::Role
    self.permissions = [:group_read]
  end

  class BeauftragterEthik < ::Role
    self.permissions = [:group_read]
  end

  class Umfeldmanager < ::Role
    self.permissions = [:group_read]
  end

  class VerantwortungAntidoping < ::Role
    self.permissions = [:group_read]
  end

  class VerantwortungClubmanagement < ::Role
    self.permissions = [:group_read]
  end

  class VerantwortungFinanzen < ::Role
    self.permissions = [:group_read]
  end

  class VerantwortungKommunikation < ::Role
    self.permissions = [:group_read]
  end

  class VerantwortungMarketing < ::Role
    self.permissions = [:group_read]
  end

  class VerantwortungMedical < ::Role
    self.permissions = [:group_read]
  end

  class VerantwortungPersonal < ::Role
    self.permissions = [:group_read]
  end

  roles JSCoach,
    Interclub,
    EventTurnier,
    BeauftragterEthik,
    Umfeldmanager,
    ChefAusbildung,
    ChefBreitensport,
    ChefLeistungssport,
    ChefNachwuchs,
    VerantwortungAntidoping,
    VerantwortungClubmanagement,
    VerantwortungFinanzen,
    VerantwortungKommunikation,
    VerantwortungMarketing,
    VerantwortungMedical,
    VerantwortungPersonal
end
