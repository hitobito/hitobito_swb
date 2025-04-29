# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class AddPeopleColumns < ActiveRecord::Migration[7.1]
  def change
    change_table(:people) do |t|
      t.integer :international_player_id
      t.text :emergency_contact
      t.boolean :newsletter, default: true, null: false
      t.boolean :advertising, default: false, null: false
    end
  end
end
