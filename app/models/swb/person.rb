# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Person
  extend ActiveSupport::Concern

  prepended do
    Person::SEARCHABLE_ATTRS << :id

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
      gender_id: -> { Ts::GENDERS[ts_gender] },
      date_of_birth: -> { "#{birthday}T00:00:00" if birthday },
      nationality: -> { Ts::COUNTRIES[nationality.to_s.upcase] if nationality },
      country: -> { Ts::COUNTRIES[country.to_s.upcase] if country },
      phone: -> { contactable_value(:phone_numbers, :landline) },
      mobile: -> { contactable_value(:phone_numbers, :mobile) },
      website: -> { contactable_value(:social_accounts, :webseite) }
    }

    alias_method :member_id, :id

    before_validation :reset_ts_gender, unless: -> { gender.blank? }

    with_options on: [:create, :update] do
      validates :first_name, :last_name, :email, :street, :zip_code, :town, :country, :birthday, :ts_gender, presence: true
      validate :assert_phone_number
    end
  end

  def ts_managed? = super && roles.any?(&:ts_managed?)

  # NOTE: override as dependent: :destroy callbacks fire before anything registered here
  def destroy
    assert_no_ts_managed_roles
    errors.none? ? super : false
  end

  private

  # NOTE enqueue ts_put in case we are managed to sync updated email
  # https://github.com/heartcombo/devise/blob/fec67f98f26fcd9a79072e4581b1bd40d0c7fa1d/lib/devise/models/confirmable.rb#L308
  def after_confirmation
    super.then do
      Ts::WriteJob.new(to_global_id, :put).enqueue! if ts_managed?
    end
  end

  def contactable_value(rel, label) = send(rel).find { |c| send(rel).model.translate_label(label) == c.label }&.value

  def reset_ts_gender = self.ts_gender = gender

  def assert_no_ts_managed_roles
    if roles.any?(&:ts_managed?)
      errors.add(:base, :cannot_be_destroyed_if_ts_roles_exist)
    end
  end

  def assert_phone_number
    if phone_numbers.select(&:valid?).empty?
      errors.add(:base, :requires_phone_number)
    end
  end
end
