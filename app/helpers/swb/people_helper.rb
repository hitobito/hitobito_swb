# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::PeopleHelper

  def format_person_ts_gender(person)
    Person.gender_labels.stringify_keys.fetch(person.ts_gender)
  end

  def format_person_nationality(person)
    ISO3166::Country[person.nationality]&.translations&.dig(I18n.locale.to_s)
  end

  def format_person_nationality_badminton(person)
    ISO3166::Country[person.nationality_badminton]&.translations&.dig(I18n.locale.to_s)
  end

  def format_person_public_profile(person)
    path = format(Settings.people.public_profile % person.id)
    link_to(path, path)
  end

  def format_person_ts_code(person)
    link_to(person.ts_code,
      "#{Ts::Config.web_host}/organization/member.aspx?mid=#{person.ts_code}")
  end

  def format_person_newsletter(person) = yes_no_badge(person.newsletter)

  def format_person_advertising(person) = yes_no_badge(person.advertising)

  def format_person_emergency_contact(person) = simple_format(person.emergency_contact)
end
