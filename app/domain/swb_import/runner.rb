# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module SwbImport
  require_relative "entity"

  class Runner
    attr_reader :lines, :log_dir

    def initialize(lines: nil, log_dir: build_log_dir)
      @lines = lines
      @log_dir = log_dir
      @index = 0
    end

    def run
      reset_db
      configure_truemail

      import(Person, from: :mitglieder)
      create_search_columns

      import(Region, from: :regions)
      import(Club, from: :clubs)

      import(Role, from: :mitglieder)

      rebuild_groups
      seed_static_people
    end

    def reset_db
      truncate_tables
      import_dachverband
    end

    def rebuild_groups = Group.rebuild!

    def create_search_columns = SearchColumnBuilder.new.run

    def configure_truemail = Truemail.configuration.default_validation_type = :regex

    def import(importer_class, from:) = Importer.new(importer_class, from, lines:, log_dir:, index: @index += 1).run

    def build_log_dir = Pathname("#{wagon_dir}/log/#{Time.zone.now.strftime("%m-%d-%H_%M_%S")}").tap do |path|
      FileUtils.mkdir_p(path)
    end

    def wagon_dir = Wagons.all[0].root

    def truncate_tables
      ActiveRecord::Base.connection.truncate_tables(:groups, :roles, :people, :invoice_configs, :phone_numbers, :social_accounts)
    end

    def import_dachverband
      Group::Dachverband.seed_once(:parent_id, name: "Swiss Badminton", street: "Talgut-Zentrum", housenumber: 27, zip_code: 3063, town: "Ittigen", country: "CH", email: "info@swiss-badminton.ch")
      PhoneNumber.seed_once(:contactable_id, :contactable_type, :number, contactable_id: Group.root.id, contactable_type: "Group", number: "+41 31 359 72 55", label: :landline)
      PhoneNumber.seed_once(:contactable_id, :contactable_type, :number, contactable_id: Group.root.id, contactable_type: "Group", number: "+41 31 359 72 59", label: :fax)
      SocialAccount.seed_once(:contactable_id, :contactable_type, :name, contactable_id: Group.root.id, contactable_type: "Group", name: "http://www.swiss-badminton.ch", label: :website)
    end

    def seed_static_people
      load(Rails.root.join("db", "seeds", "support", "person_seeder.rb"))

      puzzlers = [
        "Matthias Viehweger",
        "Nils Rauch",
        "Thomas Ellenberger",
        "Daniel Illi",
        "Andreas Maierhofer",
        "Niklas Jäggi"
      ]

      devs = {
        "Christophe Bächler" => "cbaechler@swiss-badminton.ch"
      }
      puzzlers.each do |puz|
        devs[puz] = "#{puz.split.last.downcase.gsub("ä", "ae")}@puzzle.ch"
      end

      seeder = PersonSeeder.new
      root = Group.root
      devs.each do |name, email|
        seeder.seed_developer(name, email, root, Group::Dachverband::Administrator)
      end
    end
  end
end
