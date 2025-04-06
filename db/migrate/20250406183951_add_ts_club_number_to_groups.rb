# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class AddTsClubNumberToGroups < ActiveRecord::Migration[7.1]
  def change
    change_table(:groups) do |t|
      t.integer :ts_club_number
    end
  end
end
