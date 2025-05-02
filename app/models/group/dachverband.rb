# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::Dachverband < ::Group
  self.layer = true

  children DachverbandVorstand,
    DachverbandGeschaeftsstelle,
    DachverbandKommission,
    DachverbandKader,
    DachverbandSpieler,
    DachverbandTechnischoffiziell,
    DachverbandKontakte,
    Region,
    Center,
    CenterUnaffilliated

  self.default_children = [
    DachverbandVorstand,
    DachverbandGeschaeftsstelle,
    DachverbandSpieler,
    DachverbandKontakte,
    DachverbandTechnischoffiziell
  ]

  ### ROLES

  class Administrator < ::Role
    self.permissions = [:admin, :layer_and_below_full, :impersonation]
  end

  self.event_types = [Event, Event::Tournament, Event::ExternalTraining]

  roles Administrator
end
