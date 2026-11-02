# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Group
  extend ActiveSupport::Concern

  prepended do
    # Define additional used attributes
    # self.used_attributes += [:website, :bank_account, :description]
    # self.superior_attributes = [:bank_account]

    root_types Group::Dachverband

    self.ts_entity = Ts::Entity::OrganizationGroup
    self.ts_mapping = {
      name: :name,
      code: :ts_code,
      number: -> { ts_club_number || id },
      parent_code: :parent_ts_code,
      contact: :ts_contact,
      address: :ts_address,
      postal_code: :ts_zip_code,
      city: :ts_town,
      country: :ts_country,
      email: :email,
      website: -> { contact_account_value(:social_accounts, :website) }
    }

    delegate :ts_code, to: :parent, prefix: true, allow_nil: true

    has_many :teams, dependent: :destroy

    validates :yearly_budget, inclusion: {in: Group::Budget.list.map(&:to_s)}, allow_blank: true
    validates :ts_club_number, uniqueness: true, allow_nil: true

    after_create :assign_ts_club_number, if: :assign_ts_club_number?
  end

  def ts_managed? = super && [Group::Region, Group::Verein, Group::Center].any? { |type|
    is_a?(type)
  }

  %i[address zip_code town].each do |attr|
    define_method(:"ts_#{attr}") { contact&.send(attr)&.to_s || send(attr)&.to_s }
  end

  def ts_country
    country = contact&.country || self.country
    Ts::COUNTRIES[country.to_s] if country
  end

  def ts_contact = contact&.to_s || :not_defined

  private

  def assign_ts_club_number? = attr_used?(:ts_club_number) && ts_club_number.nil?

  def assign_ts_club_number = update_column(:ts_club_number, id)
end
