# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class AddTsGenderToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column(:people, :ts_gender, :string, limit: 1, null: false, default: :m)
    reversible do |dir|
      dir.up do
        execute "UPDATE people SET ts_gender = gender WHERE gender IS NOT NULL OR gender = ''"
      end
    end
    Person.reset_column_information
  end
end
