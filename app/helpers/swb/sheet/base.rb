# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Sheet::Base
  extend ActiveSupport::Concern

  private

  module ClassMethods
    # that should be enough to hide tabs
    def current_sheet_class(view_context)
      return super unless view_context.controller.is_a?(EventsController)
      case view_context.entry
      when Event::ExternalTraining then Sheet::Event::ExternalTraining
      else super
      end
    end
  end
end
