# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::Region < ::Group
  self.layer = true
  children RegionVorstand,
    RegionMitglieder,
    RegionKontakte,
    Verein

  self.default_children = [
    RegionVorstand,
    RegionMitglieder,
    RegionKontakte
  ]

  ### ROLES

  class Administrator < ::Role
    self.permissions = [:layer_and_below_full, :contact_data, :finance]
  end

  roles Administrator
end
