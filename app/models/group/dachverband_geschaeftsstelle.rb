# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::DachverbandGeschaeftsstelle < ::Group
  self.static_name = true

  ### ROLES

  self.event_types = []

  class Geschaeftsfuehrer < ::Role
    self.permissions = [:layer_and_below_full, :admin, :approve_applications]
  end

  class Mitglied < ::Role
    self.permissions = [:group_read]
  end

  class JSCoach < ::Role
    self.permissions = [:group_read]
  end

  class Interclub < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class EventTurnier < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class Ausbildung < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class Breitensport < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class Leistungssport < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class Nachwuchs < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class Ethik < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class Umfeld < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class Antidoping < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class Clubmanagement < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class Finanzen < ::Role
    self.permissions = [:layer_and_below_full, :impersonation, :finance]
  end

  class Kommunikation < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class Marketing < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class Medical < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  class Personal < ::Role
    self.permissions = [:layer_and_below_full, :impersonation]
  end

  roles Geschaeftsfuehrer, Mitglied,
    JSCoach,
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
