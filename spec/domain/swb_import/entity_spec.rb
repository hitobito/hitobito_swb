# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe SwbImport::Entity do
  let(:csv) { {} }

  describe SwbImport::Entity do
    mapping = [[:in, :out, ->(v) { v.downcase }]]

    before do
      stub_const("TestEntity", SwbImport::Entity.new(*mapping.map(&:second), keyword_init: true) do
        self.mappings = mapping
      end)
    end

    it "raises KeyError when defined mapping is not found in attributes" do
      expect { TestEntity.from({}) }.to raise_error(KeyError)
    end

    it "maps according to defined mapping" do
      csv["in"] = "Test"
      entity = TestEntity.from(csv.symbolize_keys)
      expect(entity.out).to eq "test"
    end
  end

  describe SwbImport::Club do
    subject(:wrapper) { described_class.from(csv.symbolize_keys) }

    subject(:group) { wrapper.model }

    before do
      csv["Code"] = "c0de-1"
      csv["Number"] = 1
      csv["Name"] = "Dummy BK"
      csv["Parentnumber"] = "BRB"
      csv["Contact"] = ""
      csv["Address"] = ""
      csv["Postalcode"] = ""
      csv["City"] = ""
      csv["Phone"] = ""
      csv["Phone2"] = ""
      csv["Mobile"] = ""
      csv["Website"] = ""
    end

    it "reads default attributes" do
      expect(group.id).to eq 1
      expect(group).to be_valid
    end

    it "can save group" do
      expect(group.save).to eq true
      expect(group.reload).to be_persisted
    end

    it "defaults to a Group::Verein nested under Region" do
      expect(group.parent).to eq groups(:brb)
      expect(group).to be_kind_of(Group::Verein)
    end

    it "uses Group::Center under Dachverband if short_name is CENT" do
      csv["Parentnumber"] = "CENT"
      expect(group.parent).to eq groups(:root)
      expect(group).to be_kind_of(Group::Center)
    end

    it "can save contact data" do
      csv["Contact"] = "My Member"
      expect(wrapper.save).to eq true
      expect(group.reload).to be_present
      expect(group.contact).to eq people(:member)
    end
  end

  describe SwbImport::Person do
    subject(:person) { described_class.from(csv.symbolize_keys).model }

    before do
      csv["code"] = "1AC189B8-060E-4859-BDCB-099F208D3C3D"
      csv["memberid"] = "1"
      csv["firstname"] = "Jane"
      csv["lastname"] = "Doe"
      csv["gender"] = "f"
      csv["email"] = "JANE@example.com"
      csv["dob"] = "1986-02-19"
      csv["address"] = "Lagistrasse 13a"
      csv["postalcode"] = "3001"
      csv["city"] = "Bern"
      csv["country"] = "SUI"
      csv["phone"] = "0791234567"
      csv["mobile"] = "0791234567"
      csv["Language"] = "Deutsch (SUI)"
    end

    it "reads default attributes" do
      expect(person.id).to eq 1
      expect(person.ts_code).to eq "1AC189B8-060E-4859-BDCB-099F208D3C3D"
      expect(person.first_name).to eq "Jane"
      expect(person.last_name).to eq "Doe"
      expect(person.language).to eq "de"
      expect(person.email).to eq "jane@example.com"
      expect(person.birthday).to eq Date.new(1986, 2, 19)
      expect(person.street).to eq "Lagistrasse"
      expect(person.housenumber).to eq "13a"
      expect(person.country).to eq "CH"
      expect(person.phone_numbers).to have(2).items
      expect(person).to be_valid
    end

    it "does infer language from country" do
      csv["Language"] = "Deutsch (SUI)"
      expect(person.language).to eq "de"
    end

    it "does infer language from country" do
      csv["Language"] = "Französisch (SUI)"
      expect(person.language).to eq "fr"
    end
  end
end
