# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::EventAbility
  extend ActiveSupport::Concern

  prepended do
    on(Event::Tournament) do
      class_side(:list_available).everybody
    end
    on(Event::ExternalTraining) do
      class_side(:list_available).everybody
    end
  end
end
