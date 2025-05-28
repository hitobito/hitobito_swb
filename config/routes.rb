# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

Rails.application.routes.draw do
  extend LanguageRouteScope

  language_scope do
    resources :groups, only: [] do
      resources :events, only: [] do
        collection do
          get "tournament" => "events#index", :type => "Event::Tournament"
          get "external_training" => "events#index", :type => "Event::ExternalTraining"
        end
      end
    end

    get "list_tournaments" => "event/lists#tournaments", :as => :list_tournaments
    get "list_external_trainings" => "event/lists#external_trainings", :as => :list_external_trainings
    resources :billing_periods, except: :show
  end
end
