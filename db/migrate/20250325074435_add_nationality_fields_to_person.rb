# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class AddNationalityFieldsToPerson < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :nationality, :string, null: true
    add_column :people, :nationality_badminton, :string, null: true
  end
end
