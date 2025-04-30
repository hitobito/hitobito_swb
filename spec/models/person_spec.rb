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
      person.gender = "w"
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

  it "#member_id is aliased to #id and correctly translated" do
    expect(person.member_id).to eq person.id
    expect(Person.human_attribute_name(:member_id)).to eq "Member-ID"
  end
end
