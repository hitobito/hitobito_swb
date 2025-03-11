# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

namespace :swb do
  file "tmp/regions.csv" => ["data/Structure_SB.xlsx"] do
    `in2csv "data/Structure_SB.xlsx" --sheet "Region" > tmp/regions.csv`
  end

  file "tmp/clubs.csv" => ["data/Structure_SB.xlsx"] do
    `in2csv "data/Structure_SB.xlsx" --sheet "Clubs" > tmp/clubs.csv`
  end

  file "tmp/mitglieder.csv" => ["data/Mtglieder_Export_Hitobito.xlsx"] do
    `in2csv "data/Mtglieder_Export_Hitobito.xlsx" > tmp/mitglieder.csv`
  end

  desc "Imports Groups, People and Roles"
  task import: ["tmp/mitglieder.csv", "tmp/regions.csv", "tmp/clubs.csv", :environment] do
    SwbImport::Runner.new.run
  end
end
