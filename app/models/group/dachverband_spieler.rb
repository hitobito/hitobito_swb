# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::DachverbandSpieler < ::Group
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

  roles Aktivmitglied, Passivmitglied, JuniorU15, JuniorU19, Lizenz
end
