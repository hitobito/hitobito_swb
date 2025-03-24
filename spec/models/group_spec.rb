# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Group do
  include_examples "group types"

  describe "::validations" do
    subject(:group) { Fabricate.build(Group::Dachverband.sti_name) }

    it "is valid without yearly budget" do
      group.yearly_budget = nil
      expect(group).to be_valid
    end

    it "accepts valid yearly budget" do
      group.yearly_budget = "..5000"
      expect(group).to be_valid

      group.yearly_budget = "5000..10000"
      expect(group).to be_valid
    end

    it "rejects invalid yearly budget" do
      group.yearly_budget = ".."
      expect(group).not_to be_valid
      expect(group).to have(1).error_on(:yearly_budget)
    end
  end
end
