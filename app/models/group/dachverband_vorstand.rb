class Group::DachverbandVorstand < ::Group
  ### ROLES

  class Praesident < ::Role
    self.permissions = [:layer_full, :contact_data]
  end

  class Vizepraesident < ::Role
    self.permissions = [:layer_full, :contact_data]
  end

  class Vorstandsmitglied < ::Role
    self.permissions = [:layer_full, :contact_data]
  end

  roles Praesident, Vizepraesident, Vorstandsmitglied
end
