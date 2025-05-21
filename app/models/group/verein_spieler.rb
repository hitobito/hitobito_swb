# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::VereinSpieler < ::Group
  ### ROLES

  class Aktivmitglied < ::Role::PlayerRole
    self.permissions = [:group_read]
  end

  class Passivmitglied < ::Role::PlayerRole
    self.permissions = [:group_read]
  end

  class JuniorU15 < ::Role::PlayerRole
    self.permissions = [:group_read]
  end

  class JuniorU19 < ::Role::PlayerRole
    self.permissions = [:group_read]
  end

  class Lizenz < ::Role::PlayerRole
    self.permissions = [:group_read]
  end

  class LizenzPlusJunior < ::Role::PlayerRole
    self.permissions = [:group_read]
  end

  class LizenzPlus < ::Role::PlayerRole
    self.permissions = [:group_read]
  end

  class LizenzNoRanking < ::Role::PlayerRole
    self.permissions = [:group_read]
  end

  class Vereinigungsspieler < ::Role::PlayerRole
    self.permissions = [:group_read]
  end

  roles Aktivmitglied,
    Passivmitglied,
    JuniorU15,
    JuniorU19,
    Lizenz,
    LizenzPlusJunior,
    LizenzPlus,
    LizenzNoRanking,
    Vereinigungsspieler
end
