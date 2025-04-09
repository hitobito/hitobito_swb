# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe PeopleController do
  before { sign_in(people(:admin)) }

  context "PUT#update" do
    let(:person) { people(:admin) }

    it "can update nationality" do
      expect do
        put :update, params: {group_id: person.roles.first.group, id: person.id, person: {nationality: "CH"}}
      end.to change { person.reload.nationality }.from(nil).to("CH")
    end

    it "can update nationality_badminton" do
      expect do
        put :update, params: {group_id: person.roles.first.group, id: person.id, person: {nationality_badminton: "CH"}}
      end.to change { person.reload.nationality_badminton }.from(nil).to("CH")
    end
  end

  describe "ts write jobs" do
    context "PUT#update" do
      let(:group) { groups(:brb) }

      let(:delayed_jobs) { Delayed::Job.where("handler ilike '%Ts::WriteJob%'") }

      it "enqueues if managed" do
        person = Fabricate(:person, ts_code: Faker::Internet.uuid)
        Fabricate(Group::Region::Interclub.sti_name, group:, person:, ts_code: Faker::Internet.uuid)

        expect do
          put :update, params: {group_id: group.id, id: person.id, person: {first_name: "test"}}
        end.to change { person.reload.first_name }.to("test")
          .and change { delayed_jobs.count }.by(1)
      end

      it "does not enqueue if not managed" do
        person = Fabricate(:person)
        Fabricate(Group::Region::JSCoach.sti_name, group:, person:)
        expect do
          put :update, params: {group_id: group.id, id: person.id, person: {first_name: "test"}}
        end.to change { person.reload.first_name }.to("test")
          .and not_change { delayed_jobs.count }
      end

      it "does not enqueue if changed params are irrelevant" do
        person = Fabricate(:person, ts_code: Faker::Internet.uuid)
        Fabricate(Group::Region::Interclub.sti_name, group:, person:, ts_code: Faker::Internet.uuid)
        expect do
          put :update, params: {group_id: group.id, id: person.id, person: {family_members_attributes: {"1" => {kind: :sibling, other_id: people(:leader)}}}}
        end.to change { person.family_members.count }
          .and not_change { delayed_jobs.count }
      end
    end
  end
end
