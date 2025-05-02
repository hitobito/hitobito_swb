# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Event::Tournament < Event
  self.role_types = [
    Event::Role::Leader,
    Event::Role::AssistantLeader,
    Event::Role::Helper,
    Event::Role::Participant
  ]
  self.used_attributes -= [
    :motto,
    :cost,
    :external_applications,
    :signature,
    :signature_confirmation,
    :signature_confirmation_text
  ]
end
