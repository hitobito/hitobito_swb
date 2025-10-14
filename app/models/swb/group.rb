# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
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
      number: :id,
      parent_code: :parent_ts_code,
      contact: -> { contact&.to_s || :not_defined },
      address: :address,
      postal_code: :zip_code,
      city: :town,
      email: :email,
      country: -> { Ts::COUNTRIES[country.to_s] if country },
      website: -> { social_accounts.index_by(&:label)["website"]&.name }

    }

    delegate :ts_code, to: :parent, prefix: true, allow_nil: true

    has_many :teams, dependent: :destroy

    validates :yearly_budget, inclusion: {in: Group::Budget.list.map(&:to_s)}, allow_blank: true
  end

  def ts_managed? = super && [Group::Region, Group::Verein, Group::Center].any? { |type|
    is_a?(type)
  }
end
