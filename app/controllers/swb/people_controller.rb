# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::PeopleController
  extend ActiveSupport::Concern

  prepended do
    self.permitted_attrs += [
      :ts_gender, :nationality, :international_player_id,
      :emergency_contact, :advertising, :newsletter
    ]
  end

  private

  def filter_entries
    super.then do |scope|
      next scope unless /Spieler/.match?(parent.type) || params[:filters].present?
      scope.includes(roles: :ts_latest_log)
    end
  end

  def model_scope
    super.then do |scope|
      (action_name == "show") ? scope.includes(roles: [:ts_latest_log, group: :layer_group]) : scope
    end
  end
end
