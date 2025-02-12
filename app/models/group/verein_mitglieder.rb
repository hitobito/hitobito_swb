# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::VereinMitglieder < ::Group
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

  class Clubtrainer < ::Role
  end

  class Ehrenmitglied < ::Role
  end

  class JSExperte < ::Role
  end

  class Kaderspieler < ::Role
  end

  class Turnierorganisator < ::Role
  end

  class Volunteer < ::Role
  end

  class ZVMitglied < ::Role
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

  roles Aktivmitglied, Passivmitglied, JuniorU15, JuniorU19, Lizenz, Clubtrainer, Ehrenmitglied, JSExperte, Kaderspieler, Turnierorganisator, Volunteer, ZVMitglied, Vereinigungsspieler, LizenzPlusJunior, LizenzPlus, Shuttletime, LizenzNoRanking, JSCoach
end
