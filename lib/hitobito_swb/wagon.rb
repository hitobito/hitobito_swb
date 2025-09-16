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

      Event.prepend Swb::Event
      Group.prepend Swb::Group
      Role.prepend Swb::Role
      Person.prepend Swb::Person
      Event::ParticipationContactData.prepend Swb::Event::ParticipationContactData

      ApplicationController.include BasicAuth if Settings.basic_auth

      GroupsController.prepend TsModelController
      PeopleController.prepend TsModelController
      RolesController.prepend TsModelController
      RolesController.prepend Swb::RolesController
      RoleListsController.prepend Swb::RoleListsController

      PersonDecorator.prepend Swb::PersonDecorator

      PeopleHelper.prepend Swb::PeopleHelper
      LayoutHelper.prepend Swb::LayoutHelper
      StandardFormBuilder.prepend Swb::StandardFormBuilder

      Export::Tabular::People::PeopleAddress.prepend Swb::Export::Tabular::People::PeopleAddress

      # Tournaments with questions
      EventAbility.prepend Swb::EventAbility
      GroupAbility.prepend Swb::GroupAbility
      RoleAbility.prepend Swb::RoleAbility if FeatureGate.enabled?("roles.phases")
      Sheet::Group.prepend Swb::Sheet::Group
      Sheet::Base.prepend Swb::Sheet::Base
      EventsHelper.prepend Swb::EventsHelper
      EventResource.prepend Swb::EventResource
      Dropdown::Event::ParticipantAdd.prepend Swb::Dropdown::Event::ParticipantAdd
      Event::ListsController.prepend Swb::Event::ListsController
      EventDecorator.icons["Event::Tournament"] = :trophy

      HitobitoLogEntry.categories += %w[ts promotion]

      GroupsController.permitted_attrs += [:founded_on, :yearly_budget]
      PeopleController.prepend Swb::PeopleController
      JsonApi::EventsController.prepend Swb::JsonApi::EventsController

      Invoice.prepend Swb::Invoice
      Invoice::BatchCreate.prepend Swb::Invoice::BatchCreate
      InvoiceLists::FixedFee.prepend Swb::InvoiceLists::FixedFees
      InvoiceLists::RoleItem.prepend Swb::InvoiceLists::RoleItem
      InvoiceListsController.prepend Swb::InvoiceListsController

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

      admin_item = NavigationHelper::MAIN.find { |item| item[:label] == :admin }
      admin_item[:active_for] += %w[billing_periods]
      admin_item[:if] = ->(_) { can?(:index, CustomContent) }

      Person::FILTER_ATTRS << [:nationality, :country_select] << [:newsletter] << [:advertising]

      # Abilities
      Role::Types::Permissions << :players_group_read
      Role::PermissionImplicationsForGroups[:players_group_read] = {
        group_read: [Group::VereinSpieler, Group::RegionSpieler]
      }

      Ability.store.register BillingPeriodAbility

      # Jobs
      JobManager.wagon_jobs += [
        Roles::PromoterJob
      ]
    end

    initializer "swb.add_settings" do |_app|
      Settings.add_source!(File.join(paths["config"].existent, "settings.yml"))
      if Rails.root.join("config", "settings.local.yml")
        Settings.add_source!(Rails.root.join("config", "settings.local.yml"))
      end

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
