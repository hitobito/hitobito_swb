# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe InvoiceListsController do
  let(:group) { groups(:root) }
  let(:person) { people(:leader) }
  let(:current) { billing_periods(:current) }

  before do
    Fabricate(Group::DachverbandGeschaeftsstelle::Finanzen.sti_name, group: groups(:root_gs),
      person:)
    sign_in(person)
  end

  def create_invoice_with_billed_role_item(role)
    invoice = Invoice.create!(group: group, title: "test", recipient: person)
    item = invoice.invoice_items.create!(name: "pens", unit_cost: 2.5)
    BilledModel.create!(invoice_item: item, model: role, billing_period: current)

    invoice
  end

  it "deletes billed model associated with that invoice" do
    invoice = create_invoice_with_billed_role_item(Role.first)
    create_invoice_with_billed_role_item(Role.last)
    expect do
      travel(1.day) { delete :destroy, params: {group_id: group.id, ids: invoice.id} }
    end.to change { BilledModel.count }.by(-1)
    expect(response).to redirect_to group_invoices_path(group, returning: true)
  end

  describe "fixed fees" do
    render_views

    let(:invoice_list) { InvoiceList.last }
    let(:dom) { Capybara::Node::Simple.new(response.body) }

    describe "regions" do
      before do
        Fabricate(Group::RegionVorstand::Finanzen.sti_name, group: groups(:brb_vorstand))
        Fabricate(Group::RegionVorstand::Finanzen.sti_name, group: groups(:bvn_vorstand))
      end

      it "renders form" do
        get :new, params: {group_id: group.id, fixed_fees: :regions}
        expect(response).to be_successful

        expect(dom).not_to have_css(".alert-warning")
        expect(dom).to have_css("table td.right", text: "1'000.00 CHF")
      end

      it "can submit form" do
        expect do
          post :create,
            params: {group_id: group.id, fixed_fees: :regions,
                     invoice_list: {invoice: {title: "Regions"}}}
          expect(response).to redirect_to(group_invoice_list_invoices_path(group.id,
            invoice_list.id, returning: true))
        end.to change { Invoice.count }.by(2)
        expect(invoice_list.amount_total).to eq 1000
      end
    end

    describe "teams" do
      before do
        Fabricate(Group::VereinVorstand::Finanzen.sti_name, group: groups(:bc_bern_vorstand))
        3.times { Fabricate(:team, group: groups(:bc_bern), league: "NLA") }
      end

      it "renders form" do
        get :new, params: {group_id: group.id, fixed_fees: :teams}
        expect(response).to be_successful

        expect(dom).to have_css(".alert-warning", text: "Für folgende Gruppen konnte kein")
        expect(dom).to have_css("table td.right", text: "3'300.00 CHF")
      end

      it "can submit form" do
        expect do
          post :create,
            params: {group_id: group.id, fixed_fees: :teams,
                     invoice_list: {invoice: {title: "Teams"}}}
          expect(response).to redirect_to(group_invoice_list_invoices_path(group.id,
            invoice_list.id, returning: true))
        end.to change { Invoice.count }.by(1)
        expect(invoice_list.reload.amount_total).to eq 3300
      end
    end

    describe "roles" do
      before do
        Fabricate(Group::VereinVorstand::Finanzen.sti_name, group: groups(:bc_bern_vorstand))
        Fabricate(Group::VereinSpieler::Aktivmitglied.sti_name, group: groups(:bc_bern_spieler))
      end

      it "renders form" do
        get :new, params: {group_id: group.id, fixed_fees: :roles}
        expect(response).to be_successful

        expect(dom).to have_css(".alert-warning", text: "Für folgende Gruppen konnte kein")
        expect(dom).to have_css("table td.right", text: "30.00 CHF")
      end

      it "can submit form" do
        expect do
          post :create,
            params: {group_id: group.id, fixed_fees: :roles,
                     invoice_list: {invoice: {title: "Teams"}}}
          expect(response).to redirect_to(group_invoice_list_invoices_path(group.id,
            InvoiceList.last.id, returning: true))
        end
      end
    end
  end
end
