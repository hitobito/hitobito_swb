class Group::Region < ::Group
  self.layer = true
  children RegionVorstand,
    RegionMitglieder,
    RegionKontakte,
    Verein

  ### ROLES

  class Administrator < ::Role
    self.permissions = [:layer_and_below_full, :contact_data, :finance]
  end

  roles Administrator
end
