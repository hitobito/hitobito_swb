# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::CenterUnaffilliated < ::Group
  self.layer = true

  ### ROLES

  class Direktion < ::Role
    self.permissions = [:group_full, :contact_data]
  end

  roles Direktion

  def parent_ts_code = Ts::CENTER_PARENT_CODE
end
