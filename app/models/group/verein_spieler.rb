# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::VereinSpieler < ::Group
  ### ROLES

  class Aktivmitglied < ::Role::Player
  end

  class Passivmitglied < ::Role::Player
  end

  class JuniorU15 < ::Role::Player::JuniorU15
  end

  class JuniorU19 < ::Role::Player::JuniorU19
  end

  class Lizenz < ::Role::Player
  end

  class LizenzPlusJunior < Role::LizenzPlus
  end

  class LizenzPlus < Role::LizenzPlus
  end

  class LizenzNoRanking < ::Role::Player
  end

  class Vereinigungsspieler < ::Role::Player
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
