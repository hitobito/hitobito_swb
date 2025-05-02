# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Sheet::Group
  extend ActiveSupport::Concern

  prepended do
    tabs.insert(3,
      Sheet::Tab.new("activerecord.models.event/tournament.other",
        :tournament_group_events_path,
        params: {returning: true},
        if: lambda do |view, group|
          group.event_types.include?(::Event::Tournament) &&
            view.can?(:"index_event/tournaments", group)
        end))

    tabs.insert(4,
      Sheet::Tab.new("activerecord.models.event/external_training.other",
        :external_training_group_events_path,
        params: {returning: true},
        if: lambda do |view, group|
          group.event_types.include?(::Event::ExternalTraining) &&
            view.can?(:"index_event/external_trainings", group)
        end))
  end
end
