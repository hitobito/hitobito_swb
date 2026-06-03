# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe PlayerTransfersController do
  let(:role) { roles(:player) }
  let(:vereins_admin) { Fabricate(Group::Verein::Interclub.sti_name, group: role.group.layer_group).person }

  before { travel_to(Time.zone.local(2026, 6, 18)) } # only works in open phase

  describe "GET#new" do
    it "raises if not permitted to change role" do
      sign_in(people(:member))
      expect do
        get :new, params: {group_id: role.group_id, role_id: role.id}
      end.to raise_error(CanCan::AccessDenied)
    end

    context "authorized" do
      render_views

      before { sign_in(vereins_admin) }

      let(:dom) { Capybara::Node::Simple.new(response.body) }

      it "populates form with select and submit button" do
        get :new, params: {group_id: role.group_id, role_id: role.id}
        expect(dom).to have_css "h1", text: "Spielertransfer"
        expect(dom).to have_select "Zielverein", selected: nil, options: [
          "Bitte wählen",
          "BC Köniz",
          "BC Olten",
          "BC Pratteln",
          "BC Thun",
          "SC Uni Basel"
        ]
        expect(dom).to have_button "Transfer durchführen"
      end
    end
  end

  describe "POST#create" do
    let(:source) { role.group }
    let(:target) { groups(:bc_thun_spieler) }
    let(:player_transfer) { {target_id: target.id} }

    it "raises if not permitted to change role" do
      sign_in(people(:member))
      expect do
        post :create, params: {group_id: role.group_id, role_id: role.id, player_transfer:}
      end.to raise_error(CanCan::AccessDenied)
    end

    context "authorized" do
      before { sign_in(people(:admin)) }

      it "renders new if transfer is invalid" do
        Fabricate(Group::VereinSpieler::Aktivmitglied.sti_name, group: target, person: role.person)
        post :create, params: {group_id: role.group_id, role_id: role.id, player_transfer:}
        expect(response).to render_template(:new)
        expect(response.status).to eq 422
        expect(assigns(:player_transfer).errors.full_messages).to eq [
          "Neue Rolle ist nicht gültig (Person hat bereits eine Spielerrolle in dieser Gruppe)"
        ]
      end

      it "transfers and redirects" do
        expect do
          post :create, params: {group_id: role.group_id, role_id: role.id, player_transfer:}
        end.to change(target.roles, :count).by(1)
          .and change(source.roles, :count).by(-1)
        expect(response).to redirect_to group_people_path(source)
        expect(flash[:notice]).to eq "Transfer von BC Bern zu BC Thun wurde durchgeführt."
      end

      context "lizenz plus role" do
        let(:role) { Fabricate(Group::VereinSpieler::LizenzPlus.sti_name, group: groups(:bc_bern_spieler)) }

        it "transfers and redirects" do
          expect do
            post :create, params: {group_id: role.group_id, role_id: role.id, player_transfer:}
          end.to change(target.roles, :count).by(1)
            .and change(source.roles, :count).by(-1)
          expect(response).to redirect_to group_people_path(source)
          expect(flash[:notice]).to eq "Transfer von BC Bern zu BC Thun wurde durchgeführt."
        end

        context "non toplevel admin" do
          it "aborts and redirects" do
            sign_in(vereins_admin)
            expect do
              post :create, params: {group_id: role.group_id, role_id: role.id, player_transfer:}
            end.to not_change(target.roles, :count)
              .and not_change(source.roles, :count)
            expect(flash[:alert]).to eq "Nur Administratoren im Dachverband dürfen Lizenz Plus Spieler transferieren."
            expect(response).to redirect_to group_person_path(source, role.person_id)
          end
        end
      end
    end
  end
end
