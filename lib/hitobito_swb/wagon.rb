# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module HitobitoSwb
  class Wagon < Rails::Engine
    include Wagons::Wagon

    # Set the required application version.
    app_requirement ">= 0"

    # Add a load path for this specific wagon
    config.autoload_paths += %W[
      #{config.root}/app/abilities
      #{config.root}/app/domain
      #{config.root}/app/jobs
    ]

    config.to_prepare do
      Group.prepend TsModel
      Role.prepend TsModel
      Person.prepend TsModel

      Group.prepend Swb::Group
      Role.prepend Swb::Role
      Person.prepend Swb::Person
      Event::ParticipationContactData.prepend Swb::Event::ParticipationContactData

      GroupsController.prepend TsModelController
      PeopleController.prepend TsModelController
      RolesController.prepend TsModelController
      RolesController.prepend Swb::RolesController

      PeopleHelper.prepend Swb::PeopleHelper
      LayoutHelper.prepend Swb::LayoutHelper
      StandardFormBuilder.prepend Swb::StandardFormBuilder

      Export::Tabular::People::PeopleAddress.prepend Swb::Export::Tabular::People::PeopleAddress

      # Tournaments with questions
      EventAbility.prepend Swb::EventAbility
      GroupAbility.prepend Swb::GroupAbility
      Sheet::Group.prepend Swb::Sheet::Group
      Sheet::Base.prepend Swb::Sheet::Base
      EventsHelper.prepend Swb::EventsHelper
      EventResource.prepend Swb::EventResource
      Dropdown::Event::ParticipantAdd.prepend Swb::Dropdown::Event::ParticipantAdd
      Event::ListsController.prepend Swb::Event::ListsController
      EventDecorator.icons["Event::Tournament"] = :trophy

      HitobitoLogEntry.categories += %w[ts]

      GroupsController.permitted_attrs += [:founded_on, :yearly_budget]
      PeopleController.permitted_attrs += [
        :ts_gender, :nationality, :nationality_badminton,
        :international_player_id, :emergency_contact,
        :advertising, :newsletter
      ]

      # Navigation
      events_index = NavigationHelper::MAIN.index { |opts| opts[:label] == :events }
      NavigationHelper::MAIN.insert(
        events_index + 1,
        label: :tournaments,
        icon_name: :trophy,
        url: :list_tournaments_path,
        active_for: %w[list_tournaments],
        if: ->(_) { can?(:list_available, Event::Tournament) }
      )

      NavigationHelper::MAIN.insert(
        events_index + 2,
        label: :external_trainings,
        icon_name: :book,
        url: :list_external_trainings_path,
        active_for: %w[list_external_trainings_path],
        if: ->(_) { can?(:list_available, Event::ExternalTraining) }
      )

      Person::FILTER_ATTRS << [:nationality, :country_select] << [:nationality_badminton, :country_select] << [:newsletter] << [:advertising]
    end

    initializer "swb.add_settings" do |_app|
      Settings.add_source!(File.join(paths["config"].existent, "settings.yml"))
      Settings.reload!
    end

    initializer "swb.add_inflections" do |_app|
      ActiveSupport::Inflector.inflections do |inflect|
        # inflect.irregular 'census', 'censuses'
      end
    end

    private

    def seed_fixtures
      fixtures = root.join("db", "seeds")
      ENV["NO_ENV"] ? [fixtures] : [fixtures, File.join(fixtures, Rails.env)] # rubocop:disable Rails/EnvironmentVariableAccess
    end
  end
end
