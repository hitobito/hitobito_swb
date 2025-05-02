# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::EventsHelper
  def format_event_external_link(e)
    link_to(e.external_link, e.external_link)
  end

  def button_action_event_apply(e, group = nil)
    return super unless e.is_a?(Event::ExternalTraining)

    action_button(I18n.t("event_decorator.apply"), e.external_link, :check)
  end
end
