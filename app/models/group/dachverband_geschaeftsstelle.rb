class Group::DachverbandGeschaeftsstelle < ::Group
  ### ROLES

  class Geschaeftsfuehrer < ::Role
    self.permissions = [:layer_and_below_full, :admin, :contact_data, :approve_applications, :finance]
  end

  class Kassier < ::Role
    self.permissions = [:layer_and_below_full, :contact_data, :finance]
  end

  class Mitglied < ::Role
    self.permissions = [:layer_and_below_full, :contact_data, :approve_applications]
  end

  roles Geschaeftsfuehrer, Kassier, Mitglied
end
