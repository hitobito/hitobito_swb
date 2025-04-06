# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::Center < ::Group
  self.layer = true
  self.used_attributes += [:ts_club_number]

  ### ROLES

  class Kontakt < ::Role
  end

  class Administrator < ::Role
    self.permissions = [:layer_and_below_full, :contact_data, :finance]
  end

  roles Administrator, Kontakt

  def parent_ts_code = Ts::CENTER_PARENT_CODE
end
