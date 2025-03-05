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

  describe "ts_model" do
    let(:ts_code) { Faker::Internet.uuid }
    let(:person) { people(:leader) }
    let(:parent) { Group.new(ts_code: Faker::Internet.uuid) }
    let(:group) { Fabricate.build(Group::Region.sti_name, id: 1, name: "dummy", ts_code:, parent:) }

    subject(:ts_model) { group.ts_model }

    it "maps standard attributes" do
      expect(ts_model).to have_attributes(
        code: ts_code,
        number: 1,
        name: "dummy",
        parent_code: parent.ts_code
      )
    end

    it "maps additional attributes if present" do
      group.id = 1
      group.email = "group@example.com"
      group.housenumber = "1a"
      group.street = "Langestrasse"
      group.zip_code = 8000
      group.town = "Zürich"
      group.country = "CH"
      group.contact = person
      group.social_accounts.build(label: "website", name: "www.example.com")

      expect(ts_model).to have_attributes(
        number: 1,
        contact: "A Leader",
        address: "Langestrasse 1a",
        postal_code: 8000,
        city: "Zürich",
        country: "SUI",
        email: "group@example.com",
        website: "www.example.com"
      )
    end
  end
end
