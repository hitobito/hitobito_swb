# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe RolesController do
  before { sign_in(people(:admin)) }

  describe "ts write jobs" do
    let(:gs) { groups(:root_gs) }
    let(:interclub) { "Group::DachverbandGeschaeftsstelle::Interclub" }

    let(:person) { people(:admin) }
    let(:delayed_jobs) { Delayed::Job.where("handler ilike '%Ts::WriteJob%'") }

    context "POST#create" do
      it "enqueues if managed" do
        expect do
          post :create, params: {group_id: gs.id, role: {type: interclub, person_id: person.id}}
        end.to change { Role.count }.by(1)
          .and change { delayed_jobs.count }.by(1)
      end

      it "enqueues two if managed and person not yet managed" do
        person.update!(ts_code: nil)
        expect do
          post :create, params: {group_id: gs.id, role: {type: interclub, person_id: person.id}}
        end.to change { Role.count }.by(1)
          .and change { delayed_jobs.count }.by(2)
      end

      it "does not enqueue if invalid" do
        expect do
          post :create, params: {group_id: gs.id, role: {type: interclub, person_id: person.id, start_on: Date.tomorrow, end_on: Date.yesterday}}
        end.to not_change { Role.count }
          .and not_change { delayed_jobs.count }
      end

      it "does not enqueue if not managed" do
        person.update!(ts_code: nil)
        expect do
          post :create, params: {group_id: gs.id, role: {type: "Group::DachverbandGeschaeftsstelle::JSCoach", person_id: person.id}}
        end.to change { Role.count }
          .and not_change { delayed_jobs.count }
      end
    end

    context "PUT#update" do
      let(:leader) { roles(:leader) }
      let(:role) { Fabricate(interclub, person: people(:leader), group: gs, ts_code: Faker::Internet.uuid) }

      it "enqueues one if managed and person already managed" do
        leader.person.update(ts_code: Faker::Internet.uuid)
        expect do
          put :update, params: {group_id: role.group_id, id: role.id, role: {end_on: Date.tomorrow}}
        end.to change { role.reload.end_on }.to(Date.tomorrow)
          .and change { delayed_jobs.count }.by(1)
      end

      it "enqueues two if managed and person not yet managed" do
        expect do
          put :update, params: {group_id: role.group_id, id: role.id, role: {end_on: Date.tomorrow}}
        end.to change { role.reload.end_on }.to(Date.tomorrow)
          .and change { delayed_jobs.count }.by(2)
      end

      it "does not enqueue if not managed" do
        expect do
          put :update, params: {group_id: leader.group_id, id: leader.id, role: {end_on: Date.tomorrow}}
        end.to change { leader.reload.end_on }.to(Date.tomorrow)
          .and not_change { delayed_jobs.count }
      end

      it "does not enqueue if changed params are irrelevant" do
        expect do
          put :update, params: {group_id: role.group_id, id: role.id, role: {label: "test"}}
        end.to change { role.reload.label }.to("test")
          .and not_change { delayed_jobs.count }
      end
    end
  end
end
