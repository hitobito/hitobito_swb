# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Person do
  describe "ts_model" do
    let(:ts_code) { Faker::Internet.uuid }

    subject(:person) { people(:admin) }

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
      person.gender = "w"
      person.birthday = Date.new(1999, 12, 31)
      person.housenumber = "1a"
      person.street = "Langestrasse"
      person.zip_code = 8000
      person.town = "Zürich"
      person.country = "CH"
      person.social_accounts.build(label: "website", name: "www.example.com")
      person.phone_numbers.build(number: "+41 79 123 45 67", label: :mobile)
      person.phone_numbers.build(number: "+41 79 123 45 68", label: :landline)

      expect(ts_model).to have_attributes(
        gender_id: 2,
        date_of_birth: "1999-12-31T00:00:00",
        address: "Langestrasse 1a",
        postal_code: "8000",
        city: "Zürich",
        country: "SUI",
        mobile: "+41 79 123 45 67",
        phone: "+41 79 123 45 68",
        nationality: "SUI"
      )
    end
  end
end
