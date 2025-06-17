# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class CleanupFinanceRoles < ActiveRecord::Migration[7.1]
  def change
    reversible do |dir|
      dir.up do
        execute "DELETE FROM roles WHERE type = 'Group::VereinVorstand::Kassier'"
        execute "DELETE FROM roles WHERE type = 'Group::RegionVorstand::Kassier'"

        move_to_new_vorstand_role "Group::Region"
        move_to_new_vorstand_role "Group::Verein"
      end
    end
  end

  private

  def move_to_new_vorstand_role(layer)
    execute <<~SQL
      UPDATE roles
      SET
        type = '#{layer}Vorstand::Finanzen',
        group_id = (
          SELECT groups.id
          FROM groups
          WHERE groups.type = '#{layer}Vorstand' AND groups.layer_group_id = roles.group_id
        )
      WHERE roles.type = '#{layer}::Finanzen';
    SQL
  end
end
