class Group::DachverbandMitglieder < ::Group
  ### ROLES

  class Aktivmitglied < ::Role
  end

  class Passivmitglied < ::Role
  end

  class JuniorU15 < ::Role
  end

  class JuniorU19 < ::Role
  end

  class Lizenz < ::Role
  end

  class Vereinigungsspieler < ::Role
  end

  class LizenzPlusJunior < ::Role
  end

  class LizenzPlus < ::Role
  end

  class Shuttletime < ::Role
  end

  class LizenzNoRanking < ::Role
  end

  class JSCoach < ::Role
    self.permissions = [:group_read]
  end

  roles Aktivmitglied, Passivmitglied, JuniorU15, JuniorU19, Lizenz, Vereinigungsspieler, LizenzPlusJunior, LizenzPlus, Shuttletime, LizenzNoRanking, JSCoach
end
