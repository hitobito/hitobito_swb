# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

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
