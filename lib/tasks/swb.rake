# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

namespace :swb do
  file "tmp/regions.csv" => ["data/250828_Export_Structure_SB.xlsx"] do
    sh "in2csv --sheet Region 'data/250828_Export_Structure_SB.xlsx' > tmp/regions.csv"
  end

  file "tmp/clubs.csv" => ["data/250828_Export_Structure_SB.xlsx"] do
    sh "in2csv --sheet Club 'data/250828_Export_Structure_SB.xlsx' > tmp/clubs.csv"
  end

  file "tmp/mitglieder.csv" => ["data/250828_exportmembers.xlsx"] do
    # has bad lines with memberid AA9991
    sh "in2csv 'data/250828_exportmembers.xlsx' | grep -v AA9991 > tmp/mitglieder.csv"
  end

  file "tmp/mitglieder_without_roles.csv" => ["data/250907_Export_INACTIVE_Members_SB.xlsx"] do
    sh "in2csv 'data/250907_Export_INACTIVE_Members_SB.xlsx' > tmp/mitglieder_without_roles.csv"
  end

  file "tmp/teams.csv" => ["data/Export_Equipe_Hitobito_2026-2027_v4.xlsx"] do
    sh "in2csv --sheet Tout data/Export_Equipe_Hitobito_2026-2027_v4.xlsx > tmp/teams.csv"
  end

  desc "Imports and pushes local DB to INT"
  task import_and_push: :environment do
    system "rm -rf log"
    Rake::Task["swb:import"].invoke
    Rake::Task["swb:push"].invoke
  end

  required_csv = [
    "tmp/mitglieder.csv",
    "tmp/mitglieder_without_roles.csv",
    "tmp/regions.csv",
    "tmp/clubs.csv",
    "tmp/teams.csv"
  ]

  desc "Imports Groups, People and Roles"
  task import: required_csv + [:environment] do
    SwbImport::Runner.new.run
  end

  desc "Updates Integration with locally imported db"
  task push: :environment do
    SwbImport::Pusher.new.push
  end

  desc "Replaces all Teams with those of the current season"
  task import_teams: ["tmp/teams.csv", :environment] do
    log_dir = Pathname("log/teams-#{Time.zone.now.strftime("%m-%d-%H_%M_%S")}").tap(&:mkpath)
    SwbImport::TeamsReplacement.new(log_dir:).run
  end

  task import_mitglieder_without_roles: ["tmp/mitglieder_without_roles.csv", :environment] do
    SwbImport::Runner.new.import_mitglieder_without_roles
  end

  namespace :roles do
    desc "Schedules jobs to migrate Junioren roles from csv (#194)"
    task migrate_junioren: :environment do
      RoleChange::Runner.new.run
    end
  end

  namespace :ts do
    desc "Person Info"
    task :person, [:ts_code] => [:environment] do |_t, args|
      ts_code = args.fetch(:ts_code, ENV["TS_PERSON"])
      person = Person.find_by!(ts_code:)

      puts [person, person.roles.map(&:to_s).join(", ")].join(": ")
      ts_call("Person/#{ts_code}")
      ts_call("Person/#{ts_code}/Membership")
    end
  end

  def ts_call(path)
    # rubocop:todo Layout/LineLength
    sh "curl -s  -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization/$TS_ORGANIZATION/#{path} | xmllint  --format -"
    # rubocop:enable Layout/LineLength
  end
end
