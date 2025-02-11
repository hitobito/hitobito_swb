class Group::Dachverband < ::Group
  self.layer = true
  children DachverbandVorstand,
    DachverbandGeschaeftsstelle,
    DachverbandGremium,
    DachverbandMitglieder,
    DachverbandKontakte,
    Region,
    Center

  self.default_children = [
    DachverbandVorstand,
    DachverbandGeschaeftsstelle,
    DachverbandMitglieder,
    DachverbandKontakte
  ]

  ### ROLES

  class Administrator < ::Role
    self.permissions = [:admin, :layer_and_below_full, :impersonation]
  end

  roles Administrator
end
