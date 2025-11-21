# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe InvoiceRuns::RoleItem do
  let(:layer_group_ids) { nil }
  let(:role) { roles(:leader) }
  let(:attrs) {
    {fee: :roles, key: :aktiv, unit_cost: 1, layer_group_ids:, roles: [role.class.sti_name]}
  }

  subject(:item) { described_class.new(**attrs) }

  it "counts configured roles" do
    Fabricate(role.class.sti_name, group: role.group)
    expect(item.count).to eq 2
  end

  it "excludes billed role" do
    Fabricate(:billed_model, model: role, billing_period: billing_periods(:current))
    expect(item.count).to eq 0
  end

  it "includes role billed in different period" do
    Fabricate(:billed_model, model: role, billing_period: billing_periods(:previous))
    expect(item.count).to eq 1
  end

  it "includes non billed role in same group as billed role" do
    Fabricate(:billed_model, model: role, billing_period: billing_periods(:current))
    Fabricate(role.class.sti_name, group: role.group)
    expect(item.count).to eq 1
  end

  it "builds typed invoice item with roles" do
    Fabricate(role.class.sti_name, group: role.group)
    invoice_item = item.to_invoice_item
    expect(invoice_item).to be_a(InvoiceItem::Roles)
    expect(invoice_item).to have(2).roles
    expect(invoice_item.roles).to eq item.models
  end
end
