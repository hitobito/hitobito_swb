# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Dropdown::Event::ParticipantAdd
  extend ActiveSupport::Concern

  module ClassMethods
    def for_user(template, _group, event, _user)
      return super unless event.is_a?(Event::ExternalTraining)
      template.action_button(I18n.t("event_decorator.apply"), event.external_link, :check)
    end
  end
end
