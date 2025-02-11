class Group::Center < ::Group
  self.layer = true

  ### ROLES

  class Center < ::Role
  end

  class Kontakt < ::Role
  end

  roles Center, Kontakt
end
