# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::DachverbandGeschaeftsstelle < ::Group
  ### ROLES

  class Geschaeftsfuehrer < ::Role
    self.permissions = [:layer_and_below_full, :admin, :contact_data, :approve_applications]
  end

  class Mitglied < ::Role
    self.permissions = [:group_read]
  end

  class JSCoach < ::Role
    self.permissions = [:group_read]
  end

  class Interclub < ::Role
    self.permissions = [:layer_and_below_full, :contact_data, :impersonation]
  end

  class EventTurnier < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class ChefAusbildung < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class ChefBreitensport < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class ChefLeistungssport < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class ChefNachwuchs < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class BeauftragterEthik < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class Umfeldmanager < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class VerantwortungAntidoping < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class VerantwortungClubmanagement < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class VerantwortungFinanzen < ::Role
    self.permissions = [:layer_and_below_full, :impersonation, :finance]
  end

  class VerantwortungKommunikation < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class VerantwortungMarketing < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class VerantwortungMedical < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class VerantwortungPersonal < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  roles Geschaeftsfuehrer,
    Mitglied,
    JSCoach,
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
