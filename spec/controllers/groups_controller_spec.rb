# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe GroupsController do
  before { sign_in(people(:admin)) }

  context "PUT#update" do
    let(:group) { groups(:bvn) }

    it "can update founded_on" do
      expect do
        put :update, params: {id: group.id, group: {founded_on: Date.new(2020, 12, 24).to_s}}
      end.to change { group.reload.founded_on }.from(nil).to(Date.new(2020, 12, 24))
    end

    it "can update yearly_budget" do
      expect do
        put :update, params: {id: group.id, group: {yearly_budget: "..5000"}}
      end.to change { group.reload.yearly_budget }.from(nil).to("..5000")
    end
  end

  describe "ts write jobs" do
    let(:delayed_jobs) { Delayed::Job.where("handler ilike '%Ts::WriteJob%'") }

    context "POST#create" do
      let(:root) { groups(:root) }

      it "enqueues if managed" do
        expect do
          post :create, params: {group: {type: "Group::Region", name: "test", parent_id: root.id}}
        end.to change { Group.count }.by(4)
          .and change { delayed_jobs.count }.by(1)
      end

      it "does not enqueue if not managed" do
        expect do
          post :create,
            params: {group: {type: "Group::DachverbandKader", name: "test", parent_id: root.id}}
        end.to change { Group.count }
          .and not_change { delayed_jobs.count }
      end

      it "does not enqueue if invalid" do
        expect do
          post :create, params: {group: {type: "Group::Region", parent_id: root.id}}
        end.to not_change { Group.count }
          .and not_change { delayed_jobs.count }
      end
    end

    context "PUT#update" do
      let(:kontakte) { groups(:root_kontakte) }
      let(:group) { groups(:bvn) }

      it "enqueues if managed" do
        expect do
          put :update, params: {id: group.id, group: {name: "test"}}
        end.to change { group.reload.name }.to("test")
          .and change { delayed_jobs.count }.by(1)
      end

      it "does not enqueue if not managed" do
        expect do
          put :update, params: {id: kontakte.id, group: {description: "test"}}
        end.to change { kontakte.reload.description }.to("test")
          .and not_change { delayed_jobs.count }
      end

      it "does not enqueue if changed params are irrelevant" do
        expect do
          put :update, params: {id: group.id, group: {description: "test"}}
        end.to change { group.reload.description }.to("test")
          .and not_change { delayed_jobs.count }
      end
    end
  end
end
