# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Event::ListsController
  extend ActiveSupport::Concern

  prepended do
    skip_authorize_resource only: [:tournaments, :external_trainings]
    skip_authorize_resource only: [:external_trainings, :external_trainings]
  end

  def tournaments
    authorize!(:list_available, Event::Tournament)

    @nav_left = "tournaments"
    @tournaments = grouped(upcoming_user_events(Event::Tournament.sti_name))
  end

  def external_trainings
    authorize!(:list_available, Event::ExternalTraining)

    @nav_left = "external_trainings"
    @external_trainings = grouped(upcoming_user_events(Event::ExternalTraining.sti_name))
  end

  private

  def upcoming_user_events(type = [nil, Event.sti_name])
    super().where(type:)
  end
end
