#  Copyright (c) 2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class AddUniqueIndexToGroupsTsClubNumber < ActiveRecord::Migration[8.0]
  def change
    add_index :groups, :ts_club_number, unique: true, where: "ts_club_number IS NOT NULL"
  end
end
