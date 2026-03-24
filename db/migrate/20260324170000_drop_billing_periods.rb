#  Copyright (c) 2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class DropBillingPeriods < ActiveRecord::Migration[8.0]
  def up
    drop_table :billed_models
    drop_table :billing_periods
  end

  def down
    create_table "billing_periods", force: :cascade do |t|
      t.string "name", null: false
      t.boolean "active", default: false, null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["active"], name: "index_billing_periods_on_active", unique: true, where: "(active = true)"
    end

    create_table "billed_models", force: :cascade do |t|
      t.bigint "billing_period_id"
      t.string "model_type"
      t.bigint "model_id"
      t.bigint "invoice_item_id"
      t.index ["billing_period_id"], name: "index_billed_models_on_billing_period_id"
      t.index ["invoice_item_id"], name: "index_billed_models_on_invoice_item_id"
      t.index ["model_id", "model_type", "billing_period_id"], name: "idx_on_model_id_model_type_billing_period_id_cf6c18435e", unique: true
      t.index ["model_type", "model_id"], name: "index_billed_models_on_model"
    end
  end
end
