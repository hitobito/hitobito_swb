# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class AddBillingPeriods < ActiveRecord::Migration[7.1]
  def change
    create_table(:billing_periods) do |t|
      t.string :name, null: false
      t.boolean :active, null: false, default: false
      t.timestamps
      t.index :active, unique: true, where: "(active = true)"
    end

    create_table(:billed_models) do |t|
      t.belongs_to :billing_period
      t.belongs_to :model, polymorphic: true
      t.belongs_to :invoice_item
      t.index [:model_id, :model_type, :billing_period_id], unique: true
    end
  end
end
