#  Copyright (c) 2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class UpdateContactAccountLabels < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        update_labels(:social_accounts, :website, :Webseite)
        update_labels(:phone_numbers, :Festnetz, :landline)
        update_labels(:phone_numbers, :Mobil, :mobile)
      end
    end
  end

  def update_labels(table, from, to)
    execute "UPDATE #{table} SET label = '#{to}' WHERE label = '#{from}'"
  end
end
