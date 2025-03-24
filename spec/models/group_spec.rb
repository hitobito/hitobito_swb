# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Group do
  include_examples "group types"

  describe "#formatted_yearly_budget_range" do
    let(:group) { Group.new }

    it "formats regular range" do
      group.yearly_budget_range = (0..5000)
      expect(group.formatted_yearly_budget_range).to eq("0-5000")
    end

    it "formats endless range" do
      group.yearly_budget_range = (15000..)
      expect(group.formatted_yearly_budget_range).to eq("15000-")
    end

    it "formats nil value" do
      group.yearly_budget_range = nil
      expect(group.formatted_yearly_budget_range).to eq(nil)
    end
  end
end
