class Group::Verein < ::Group
  self.layer = true
  children VereinVorstand,
    VereinMitglieder,
    VereinKontakte

  ### ROLES

  class Hauptleitung < ::Role
    self.permissions = [:layer_and_below_full]
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

  roles Hauptleitung, Adressverwaltung, Leitung, Aktivmitglied
end
