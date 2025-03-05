# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Person
  extend ActiveSupport::Concern

  prepended do
    self.ts_entity = Ts::Entity::OrganizationPerson

    self.ts_mapping = {
      code: :ts_code,
      member_id: :id,
      email: :email,
      firstname: :first_name,
      lastname: :last_name,
      address: :address,
      postal_code: :zip_code,
      city: :town,
      gender_id: -> { Ts::GENDERS[gender] if gender },
      date_of_birth: -> { "#{birthday}T00:00:00" if birthday },
      nationality: -> { Ts::COUNTRIES[country.to_s] if country },
      country: -> { Ts::COUNTRIES[country.to_s] if country },
      phone: -> { phone_numbers.index_by(&:label)["landline"]&.number },
      mobile: -> { phone_numbers.index_by(&:label)["mobile"]&.number },
      website: -> { social_accounts.index_by(&:label)["website"]&.name }
    }
  end

  def ts_managed? = super && roles.any?(&:ts_managed?)
end
