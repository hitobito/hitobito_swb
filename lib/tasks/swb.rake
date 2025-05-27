# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

namespace :swb do
  file "tmp/regions.csv" => ["data/exportLevel-Regions-19032025.xlsx"] do
    sh "in2csv 'data/exportLevel-Regions-19032025.xlsx' > tmp/regions.csv"
  end

  file "tmp/clubs.csv" => ["data/exportLevel-Clubs-19032025.xlsx"] do
    sh "in2csv 'data/exportLevel-Clubs-19032025.xlsx' > tmp/clubs.csv"
  end

  file "tmp/mitglieder.csv" => ["data/Mtglieder_Export_Hitobito.xlsx"] do
    sh "in2csv 'data/Mtglieder_Export_Hitobito.xlsx' > tmp/mitglieder.csv"
  end

  file "tmp/teams.csv" => ["data/Mtglieder_Export_Hitobito.xlsx"] do
    sh "in2csv --sheet Teams_Eli   data/Export_Manschaften.xlsx  > tmp/teams_eli.csv"
    sh "in2csv --sheet Teams_Jun   data/Export_Manschaften.xlsx  > tmp/teams_jun.csv"
    sh "in2csv --sheet Teams_Sen   data/Export_Manschaften.xlsx  > tmp/teams_sen.csv"
    sh "in2csv --sheet Vereinigung data/Export_Manschaften.xlsx  > tmp/teams_ver.csv"
  end

  desc "Imports and pushes local DB to INT"
  task import_and_push: :environment do
    system "rm -rf log"
    Rake::Task["swb:import"].invoke
    Rake::Task["swb:push"].invoke
  end

  required_csv = [
    "tmp/mitglieder.csv",
    "tmp/regions.csv",
    "tmp/clubs.csv",
    "tmp/teams_eli.csv",
    "tmp/teams_jun.csv",
    "tmp/teams_sen.csv",
    "tmp/teams_ver.csv"
  ]

  desc "Imports Groups, People and Roles"
  task import: required_csv + [:environment] do
    SwbImport::Runner.new.run
  end

  desc "Updates Integration with locally imported db"
  task push: :environment do
    SwbImport::Pusher.new.push
  end

  desc "Imports Teams for current year"
  task import_teams: ["tmp/teams_eli.csv", "tmp/teams_jun.csv", "tmp/teams_sen.csv", "tmp/teams_ver.csv", :environment] do
    SwbImport::Importer.new(SwbImport::Team, :teams_eli).run
    SwbImport::Importer.new(SwbImport::TeamJun, :teams_jun).run
    SwbImport::Importer.new(SwbImport::TeamSen, :teams_sen).run
    SwbImport::Importer.new(SwbImport::Team, :teams_ver).run
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
    sh "curl -s  -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization/$TS_ORGANIZATION/#{path} | xmllint  --format -"
  end
end
