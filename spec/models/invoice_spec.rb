# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Invoice do
  let(:group) { groups(:root) }
  let(:recipient) { people(:leader) }
  let(:role) { roles(:leader) }
  let(:current) { billing_periods(:current) }

  def build_roles_invoice(roles: [role])
    Fabricate.build(:invoice, group:, recipient:, invoice_items_attributes: {
      "1" => {type: "InvoiceItem::Roles", name: :roles, unit_cost: 1, count: 1, roles:}
    })
  end

  describe "with roles invoice item" do
    it "creates billed models for each role" do
      expect do
        build_roles_invoice(roles: [roles(:leader), roles(:admin)]).save
      end.to change { BilledModel.where(model_type: "Role", billing_period: current).count }.by(2)
    end

    it "canceling invoice deletes billed models" do
      invoice = build_roles_invoice(roles: [roles(:leader), roles(:admin)]).tap(&:save)
      expect do
        invoice.update(state: :cancelled)
      end.to change { BilledModel.where(model_type: "Role", billing_period: current).count }.by(-2)
    end
  end
end
