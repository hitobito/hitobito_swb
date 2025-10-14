# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Person do
  subject(:person) { people(:admin) }

  describe "ts_model" do
    let(:ts_code) { Faker::Internet.uuid }

    subject(:ts_model) { person.ts_model }

    it "maps standard attributes" do
      expect(ts_model).to have_attributes(
        member_id: ActiveRecord::FixtureSet.identify(:admin),
        firstname: "Chief",
        lastname: "Admin",
        email: "admin@hitobito.example.com",
        code: "9034c579-68fe-49f9-b416-24b216a053c6"
      )
    end

    it "maps additional attributes if present" do
      person.language = "fr"
      person.gender = "nil"
      person.ts_gender = "w"
      person.birthday = Date.new(1999, 12, 31)
      person.housenumber = "1a"
      person.street = "Langestrasse"
      person.zip_code = 8000
      person.town = "Zürich"
      person.country = "ch"
      person.nationality = "de"
      person.social_accounts.build(name: "www.example.com", label: "Webseite")
      person.phone_numbers.build(number: "+41 79 123 45 67", label: "Mobil")
      person.phone_numbers.build(number: "+41 79 123 45 68", label: "Festnetz")

      expect(ts_model).to have_attributes(
        gender_id: 2,
        date_of_birth: "1999-12-31T00:00:00",
        address: "Langestrasse 1a",
        postal_code: "8000",
        city: "Zürich",
        country: "SUI",
        nationality: "GER",
        mobile: "+41 79 123 45 67",
        phone: "+41 79 123 45 68",
        website: "www.example.com"
      )
    end
  end

  describe "::validations" do
    let(:person) { Fabricate.build(:person) }

    it "is invalid when phone_numbers are empty" do
      person.phone_numbers = []
      expect(person).not_to be_valid
      expect(person.errors.full_messages).to eq ["Es muss eine Telefonnummer hinterlegt werden."]
    end

    it "verifies that changing birthday does not invalidate player role" do
      person.birthday = 13.years.ago
      person.save!
      Fabricate(Group::VereinSpieler::JuniorU15.sti_name, group: groups(:bc_bern_spieler), person:)
      person.birthday = 20.years.ago
      expect(person).not_to be_valid
      # rubocop:todo Layout/LineLength
      expect(person.errors.full_messages).to eq ["Geburtstag ist nicht gültig für aktuelle Spieler Rollen"]
      # rubocop:enable Layout/LineLength
    end
  end

  it "#member_id is aliased to #id and correctly translated" do
    expect(person.member_id).to eq person.id
    expect(Person.human_attribute_name(:member_id)).to eq "Member-ID"
  end

  describe "ts_gender" do
    let(:person) { Fabricate.build(:person) }

    it "is infered from actual gender" do
      person.gender = "m"
      expect(person).to be_valid
      expect(person.ts_gender).to eq "m"

      person.gender = "w"
      expect(person).to be_valid
      expect(person.ts_gender).to eq "w"
    end

    it "is invalid when gender is set to nil and ts_gender is not set" do
      person.ts_gender = nil
      person.gender = nil
      expect(person).not_to be_valid
      expect(person.errors.full_messages).to eq ["Geschlecht Spielbetrieb muss ausgefüllt werden"]
    end
  end

  describe "#destroy" do
    it "may not be destroyed if ts managed roles exist" do
      Fabricate(Group::Region::Interclub.sti_name, group: groups(:brb), person:,
        ts_code: Faker::Internet.uuid)
      expect(person.destroy).to eq(false)
      # rubocop:todo Layout/LineLength
      expect(person.errors.full_messages).to eq ["Kann nicht gelöscht werden solange TS Rollen existieren."]
      # rubocop:enable Layout/LineLength
    end
  end
end
