class Group::Region < ::Group
  self.layer = true
  children RegionVorstand,
    RegionMitglieder,
    RegionKontakte,
    Verein

  self.default_children = [
    RegionVorstand,
    RegionMitglieder,
    RegionKontakte
  ]

  ### ROLES

  class Administrator < ::Role
    self.permissions = [:layer_and_below_full, :contact_data, :finance]
  end

  roles Administrator
end
