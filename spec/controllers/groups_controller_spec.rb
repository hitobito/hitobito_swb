# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe GroupsController do
  before { sign_in(people(:admin)) }

  let(:group) { groups(:bvn) }

  context "PUT#update" do
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
end
