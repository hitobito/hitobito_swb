#  Copyright (c) 2012-2024, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

class AddNationalityFieldsToPerson < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :nationality, :string, null: true
    add_column :people, :nationality_badminton, :string, null: true
  end
end
