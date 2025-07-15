# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe RolesController do
  describe "changing player roles" do
    let(:gs) { groups(:root_gs) }
    let(:group) { groups(:bc_bern_spieler) }
    let(:tomorrow) { Time.zone.tomorrow }

    let(:person) { people(:leader) }
    let(:one_year_ago) { 1.year.ago.to_date }
    let(:one_week_ago) { 1.week.ago.to_date }
    let!(:role) { Fabricate(Group::VereinSpieler::Aktivmitglied.sti_name, person:, group:, start_on: one_year_ago, created_at: one_year_ago) }

    describe "GET#edit" do
      render_views
      let(:dom) { Capybara::Node::Simple.new(response.body) }

      context "as admin" do
        before { sign_in(people(:admin)) }

        it "has start_on field" do
          get :edit, params: {group_id: group.id, id: role.id}
          expect(dom).to have_field("Von")
        end
      end

      context "as vereins admin" do
        let(:vereins_admin) { Fabricate(Group::VereinVorstand::Administrator.sti_name, group: groups(:bc_bern_vorstand)) }

        before { sign_in(vereins_admin.person) }

        it "hides start_on field" do
          get :edit, params: {group_id: group.id, id: role.id}
          expect(dom).not_to have_field("Von")
        end

        context "on normal role" do
          let(:role) { vereins_admin }

          it "shows start_on field" do
            get :edit, params: {group_id: role.group_id, id: role.id}
            expect(dom).to have_field("Von")
          end
        end
      end
    end

    describe "PUT#update" do
      context "as admin" do
        before { sign_in(people(:admin)) }

        it "allows setting start_on" do
          expect do
            put :update, params: {group_id: group.id, id: role.id, role: {type: Group::VereinSpieler::Passivmitglied.sti_name, start_on: one_week_ago}}
          end.not_to change { person.roles.count }
          expect(person.roles.find_by(type: "Group::VereinSpieler::Passivmitglied").start_on).to eq one_week_ago
          expect(person.roles.with_inactive.find_by(type: "Group::VereinSpieler::Aktivmitglied").end_on).to eq Time.zone.yesterday
        end
      end

      context "as vereins admin" do
        before { sign_in(Fabricate(Group::VereinVorstand::Administrator.sti_name, group: groups(:bc_bern_vorstand)).person) }

        it "ignores start_on param and sets it to today" do
          expect do
            put :update, params: {group_id: group.id, id: role.id, role: {type: Group::VereinSpieler::Passivmitglied.sti_name, start_on: one_week_ago}}
          end.not_to change { person.roles.count }
          expect(person.roles.find_by(type: "Group::VereinSpieler::Passivmitglied").start_on).to eq Time.zone.today
          expect(person.roles.with_inactive.find_by(type: "Group::VereinSpieler::Aktivmitglied").end_on).to eq Time.zone.yesterday
        end
      end
    end
  end

  describe "ts write jobs" do
    before { sign_in(people(:admin)) }

    let(:gs) { groups(:root_gs) }
    let(:interclub) { "Group::DachverbandGeschaeftsstelle::Interclub" }

    let(:person) { people(:admin) }
    let(:leader) { roles(:leader) }
    let(:managed_role) { Fabricate(interclub, person: people(:leader), group: gs, ts_code: Faker::Internet.uuid) }

    let(:write_jobs) { Delayed::Job.where("handler ilike '%Ts::WriteJob%'") }
    let(:delete_jobs) { Delayed::Job.where("handler ilike '%Ts::RoleDestroyJob%'") }

    context "POST#create" do
      it "enqueues if managed" do
        expect do
          post :create, params: {group_id: gs.id, role: {type: interclub, person_id: person.id}}
        end.to change { Role.count }.by(1)
          .and change { write_jobs.count }.by(1)
      end

      it "enqueues two if managed and person not yet managed" do
        person.update!(ts_code: nil)
        expect do
          post :create, params: {group_id: gs.id, role: {type: interclub, person_id: person.id}}
        end.to change { Role.count }.by(1)
          .and change { write_jobs.count }.by(2)
      end

      it "does not enqueue if invalid" do
        expect do
          post :create, params: {group_id: gs.id, role: {type: interclub, person_id: person.id, start_on: Date.tomorrow, end_on: Date.yesterday}}
        end.to not_change { Role.count }
          .and not_change { write_jobs.count }
      end

      it "does not enqueue if not managed" do
        person.update!(ts_code: nil)
        expect do
          post :create, params: {group_id: gs.id, role: {type: "Group::DachverbandGeschaeftsstelle::JSCoach", person_id: person.id}}
        end.to change { Role.count }
          .and not_change { write_jobs.count }
      end

      it "accepts all person attributes" do
        expect do
          post :create, params: {
            group_id: gs.id, role: {
              type: "Group::DachverbandGeschaeftsstelle::JSCoach", group_id: gs.id, person_id: nil,
              new_person: {
                first_name: "Dario",
                last_name: "Ahlke",
                email: "dario.ahlke2@hitobito.example.com",
                birthday: "03.02.1983",
                street: "Bahnhof Str.",
                housenumber: "2",
                zip_code: 6414,
                town: "Ivanstadt",
                country: "CH",
                nationality: "CH",
                gender: "m",
                phone_numbers_attributes: {"0" => {translated_label: "Mobil", number: "0781234567", public: false}}
              }
            }
          }
        end.to change { Role.count }.by(1)
          .and change { Person.count }.by(1)
          .and change { PhoneNumber.count }.by(1)
      end
    end

    context "PUT#update" do
      it "enqueues one if managed and person already managed" do
        leader.person.update(ts_code: Faker::Internet.uuid)
        expect do
          put :update, params: {group_id: managed_role.group_id, id: managed_role.id, role: {end_on: Date.tomorrow}}
        end.to change { managed_role.reload.end_on }.to(Date.tomorrow)
          .and change { write_jobs.count }.by(1)
      end

      it "enqueues two if managed and person not yet managed" do
        expect do
          put :update, params: {group_id: managed_role.group_id, id: managed_role.id, role: {end_on: Date.tomorrow}}
        end.to change { managed_role.reload.end_on }.to(Date.tomorrow)
          .and change { write_jobs.count }.by(2)
      end

      it "does not enqueue if not managed" do
        expect do
          put :update, params: {group_id: leader.group_id, id: leader.id, role: {end_on: Date.tomorrow}}
        end.to change { leader.reload.end_on }.to(Date.tomorrow)
          .and not_change { write_jobs.count }
      end

      it "does not enqueue if changed params are irrelevant" do
        expect do
          put :update, params: {group_id: managed_role.group_id, id: managed_role.id, role: {label: "test"}}
        end.to change { managed_role.reload.label }.to("test")
          .and not_change { write_jobs.count }
      end

      describe "changing type" do
        it "does not enqueue anything if no role type is managed" do
          expect do
            put :update, params: {group_id: leader.group_id, id: leader.id, role: {type: "Group::DachverbandGeschaeftsstelle::Mitglied", group_id: leader.group_id}}
          end.to not_change { Role.count }
            .and not_change { write_jobs.count }
            .and not_change { delete_jobs.count }
          expect(leader.person.reload.roles.pluck(:type)).to eq ["Group::DachverbandGeschaeftsstelle::Mitglied"]
        end

        it "enqueues two write jobs when changing to managed role and person not yet managed" do
          expect do
            put :update, params: {group_id: leader.group_id, id: leader.id, role: {type: "Group::DachverbandGeschaeftsstelle::Interclub", group_id: leader.group_id}}
          end.to not_change { Role.count }
            .and not_change { delete_jobs.count }
            .and change { write_jobs.count }.by(2)
        end

        it "enqueues single write and delete job when changing to managed role and person and deleted role are managed" do
          other = Fabricate(Group::Region::Interclub.sti_name, person: people(:leader), group: groups(:brb), ts_code: Faker::Internet.uuid)

          expect do
            put :update, params: {group_id: other.group_id, id: other.id, role: {type: "Group::DachverbandGeschaeftsstelle::Interclub", group_id: leader.group_id}}
          end.to not_change { Role.count }
            .and change { delete_jobs.count }.by(1)
            .and change { write_jobs.count }.by(2)
        end

        it "enqueues single delete job when changing from managed to non managed role" do
          managed_role # initialize

          expect do
            put :update, params: {group_id: managed_role.group_id, id: managed_role.id, role: {type: "Group::Region::EventTurnier", group_id: groups(:brb).id}}
          end.to not_change { Role.count }
            .and change { delete_jobs.count }.by(1)
            .and not_change { write_jobs.count }
        end
      end
    end

    context "DELETE#destroy" do
      it "does enqueue job" do
        expect do
          delete :destroy, params: {group_id: managed_role.group_id, id: managed_role.id}
        end.to change { Role.where(id: managed_role.id).count }.by(-1)
          .and change { delete_jobs.count }
          .and not_change { write_jobs.count }

        delete_job = delete_jobs.first.payload_object
        [:id, :ts_code, :person_id, :group_id, :start_on].each do |attr|
          expect(delete_job.attrs[attr]).to eq managed_role.send(attr)
        end
        expect(delete_job.attrs[:end_on]).to eq Time.zone.yesterday
      end

      it "does not enqueue if not managed" do
        expect do
          delete :destroy, params: {group_id: leader.group_id, id: leader.id}
        end.to change { Role.where(id: leader.id).count }.by(-1)
          .and not_change { delete_jobs.count }
          .and not_change { write_jobs.count }
      end

      it "does not enqueue if managed but not yet synced" do
        managed_role.update!(ts_code: nil)
        expect do
          delete :destroy, params: {group_id: managed_role.group_id, id: managed_role.id}
        end.to change { Role.where(id: managed_role.id).count }.by(-1)
          .and not_change { delete_jobs.count }
          .and not_change { write_jobs.count }
      end
    end
  end
end
