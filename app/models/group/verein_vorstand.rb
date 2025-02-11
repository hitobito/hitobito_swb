class Group::VereinVorstand < ::Group
  ### ROLES

  class Praesident < ::Role
    self.permissions = [:layer_full, :contact_data]
  end

  class Vizepraesident < ::Role
    self.permissions = [:layer_full, :contact_data]
  end

  class Kassier < ::Role
    self.permissions = [:layer_read, :contact_data, :finance]
  end

  class Vorstandsmitglied < ::Role
    self.permissions = [:layer_full, :contact_data]
  end

  roles Praesident, Vizepraesident, Kassier, Vorstandsmitglied
end
