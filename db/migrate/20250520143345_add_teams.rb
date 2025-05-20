# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class AddTeams < ActiveRecord::Migration[7.1]
  def change
    create_table(:teams) do |t|
      t.belongs_to :group
      t.string :league, null: false
      t.string :name, null: false
      t.integer :year, null: false
      t.timestamps
      t.index [:group_id, :name, :year], unique: true
    end
  end
end
