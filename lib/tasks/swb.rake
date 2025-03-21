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

  desc "Imports and pushes local DB to INT"
  task import_and_push: :environment do
    system "rm -rf log"
    Rake::Task["swb:import"].invoke
    Rake::Task["swb:push"].invoke
  end

  desc "Imports Groups, People and Roles"
  task import: ["tmp/mitglieder.csv", "tmp/regions.csv", "tmp/clubs.csv", :environment] do
    SwbImport::Runner.new.run
  end

  desc "Updates Integration with locally imported db"
  task push: :environment do
    cluster_psql = "$HOME/dev/hitobito/hitobito-ops/bin/postgresql"
    pg_dump = "/usr/lib/postgresql/16/bin/pg_dump"
    db_dump = "tmp/dump.sql"
    puts "Dumping local schema"
    ActiveRecord::Base.connection.execute "ALTER SCHEMA public RENAME TO database"
    system("PGPASSWORD=$RAILS_DB_PASSWORD #{pg_dump} -cOx -h $RAILS_DB_HOST -U $RAILS_DB_USERNAME $RAILS_DB_NAME > #{db_dump}")
    ActiveRecord::Base.connection.execute "ALTER SCHEMA database RENAME TO public"
    project = `oc project -q`.strip
    fail "Unexpected project: #{project}" unless project == "hit-swb-int"
    puts "Updating remote database"
    system("#{cluster_psql} < #{db_dump}")
  end
end
