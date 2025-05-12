# frozen_string_literal: true

#  Copyright (c) 2020-2024, Insieme Schweiz. This file is part of
#  hitobito_insieme and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_insieme.

Fabrication.manager.schematics[:core_person] =
  Fabrication.manager.schematics.delete(:person)

Fabricator(:person, from: :core_person) do
  ts_gender { |attrs| attrs[:gender].presence || Person::GENDERS.sample }
  birthday { Faker::Date.between(from: 110.years.ago, to: 12.years.ago) }
  gender { (Person::GENDERS + [""]).sample }
  street { Faker::Address.street_name }
  housenumber { Faker::Address.building_number }
  town { Faker::Address.city }
  country { %w[DE CH FR AT US].sample }
  zip_code { |attrs| Faker::Number.number(digits: (%w[AT CH].include?(attrs[:country]) ? 4 : 5)) }
  after_build { phone_numbers.build(label: %w[landline mobile].sample, number: Faker::Base.numerify("+41 77 ### ## ##")) }
end
