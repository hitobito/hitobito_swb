# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe RoleListsController do
  let(:group) { groups(:bc_bern) }
  let(:tomorrow) { Time.zone.tomorrow }

  let(:write_jobs) { Delayed::Job.where("handler ilike '%Ts::WriteJob%'") }
  let(:delete_jobs) { Delayed::Job.where("handler ilike '%Ts::RoleDestroyJob%'") }

  before { sign_in(people(:admin)) }

  describe "POST#create" do
    let!(:person) do
      Fabricate(Group::Verein::Ausbildung.sti_name, group: group,
        person: Fabricate(:person, ts_code: Faker::Internet.uuid)).person
    end

    it "allows creation of normal role" do
      expect do
        post :create,
          params: {group_id: group.id, ids: person.id,
                   role: {type: Group::Verein::JSCoach.sti_name, group_id: group.id}}
      end.to change { group.roles.count }.by(1)

      expect(response).to redirect_to group_people_path(group)
      expect(flash[:notice]).to be_present
    end

    it "allows creation of ts managed role" do
      expect do
        post :create,
          params: {group_id: group.id, ids: person.id,
                   role: {type: Group::Verein::Interclub.sti_name, group_id: group.id}}
      end.to change { group.roles.count }
        .and change { write_jobs.count }.by(1)

      expect(response).to redirect_to group_people_path(group)
      expect(flash[:notice]).to eq "Eine Rolle wurde erstellt"
    end
  end

  describe "POST#create of player roles" do
    let(:spieler) { groups(:bc_bern_spieler) }
    let(:licence) { Group::VereinSpieler::JuniorU19 }
    let(:holder) { junior_in_verein }
    let(:newcomer) { junior_in_verein }

    def junior_in_verein
      person = Fabricate(:person, birthday: 16.years.ago.to_date)
      Fabricate(Group::Verein::Ausbildung.sti_name, group:, person:)
      person
    end

    before do
      Fabricate(licence.sti_name, group: spieler, person: holder)
      sign_in(Fabricate(Group::VereinVorstand::Administrator.sti_name,
        group: groups(:bc_bern_vorstand)).person)
    end

    shared_examples "bulk assignment with an existing holder" do
      it "creates role for people without it even if others already hold it" do
        expect do
          post :create, params: {group_id: group.id, ids: [holder.id, newcomer.id].join(","),
                                 role: {type: licence.sti_name, group_id: spieler.id}}
        end.to change { newcomer.roles.where(group: spieler, type: licence.sti_name).count }.by(1)

        expect(flash[:notice]).to eq "Eine Rolle wurde erstellt"
        expect(flash[:alert]).to eq "Eine Rolle konnte nicht erstellt werden"
      end
    end

    context "in reduced phase" do
      around { |example| travel_to(Date.new(2026, 10, 1)) { example.run } }

      it_behaves_like "bulk assignment with an existing holder"
    end

    context "in restricted phase" do
      around { |example| travel_to(Date.new(2026, 3, 1)) { example.run } }

      it_behaves_like "bulk assignment with an existing holder"
    end
  end

  describe "PUT#update" do
    it "allows changing from normal to normal type" do
      role = Fabricate(Group::Verein::Ausbildung.sti_name, group: group)
      expect do
        put :update, params: {
          group_id: group.id,
          ids: role.person_id,
          role: {
            types: {"Group::Verein::Ausbildung" => "1"},
            type: Group::Verein::JSCoach.sti_name,
            group_id: group.id
          }
        }
      end.to change {
               role.person.reload.roles.last.type
             }.from(role.type).to("Group::Verein::JSCoach")

      expect(response).to redirect_to group_people_path(group)
      expect(flash[:notice]).to be_present
    end

    it "allows changing ts managed role" do
      role = Fabricate(Group::Verein::Interclub.sti_name, group: group,
        ts_code: Faker::Internet.uuid)
      expect do
        put :update, params: {
          group_id: group.id,
          ids: role.person_id,
          role: {
            types: {"Group::Verein::Interclub" => "1"},
            type: Group::Verein::JSCoach.sti_name,
            group_id: group.id
          }
        }
      end.to change { delete_jobs.count }.by(1)

      expect(response).to redirect_to group_people_path(group)
      expect(flash[:notice]).to eq "Eine Rolle wurde verschoben"
    end
  end

  describe "DELETE#destroy" do
    it "allows deletion normal role" do
      role = Fabricate(Group::Verein::Ausbildung.sti_name, group: group)
      expect do
        delete :destroy,
          params: {group_id: group.id, ids: role.person_id,
                   role: {types: {"Group::Verein::Ausbildung" => "1"}}}
      end.to change { group.roles.count }.by(-1)

      expect(response).to redirect_to group_people_path(group)
      expect(flash[:notice]).to be_present
    end

    it "allows deletion of ts managed role" do
      role = Fabricate(Group::Verein::Interclub.sti_name, group: group)
      expect do
        delete :destroy,
          params: {group_id: group.id, ids: role.person_id,
                   role: {types: {"Group::Verein::Interclub" => "1"}}}
      end.to change { group.roles.count }.by(-1)
        .and change { delete_jobs.count }.by(1)

      expect(response).to redirect_to group_people_path(group)
      expect(flash[:notice]).to eq "Eine Rolle wurde entfernt"
    end
  end
end
