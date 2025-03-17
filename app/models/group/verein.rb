# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::Verein < ::Group
  self.layer = true
  children VereinVorstand,
    VereinMitglieder,
    VereinKontakte

  self.default_children = [
    VereinVorstand,
    VereinMitglieder,
    VereinKontakte
  ]

  ### ROLES

  class Administrator < ::Role
    self.permissions = [:layer_and_below_full, :contact_data]
  end

  class Adressverwaltung < ::Role
    self.permissions = [:group_and_below_full]
  end

  class Leitung < ::Role
    self.permissions = [:group_and_below_full, :contact_data]
  end

  class Aktivmitglied < ::Role
    self.permissions = [:group_and_below_read]
  end

  roles Administrator, Adressverwaltung, Leitung, Aktivmitglied
end
