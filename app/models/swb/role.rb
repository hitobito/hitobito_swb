# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Role
  extend ActiveSupport::Concern

  OPEN_END = Time.zone.parse("9999-12-31T23:59:59")

  prepended do
    delegate :ts_role, :ts_membership, to: :model_name

    self.ts_entity = Ts::Entity::OrganizationMembership
    self.ts_mapping = {
      code: :ts_code,
      start_date: -> { (start_on&.midnight || created_at).iso8601 },
      end_date: -> { (end_on&.midnight || OPEN_END).iso8601 },
      organization_group_code: -> { group&.ts_code || group&.parent_ts_code },
      organization_role_code: -> { ts_role&.code },
      organization_membership_code: -> { ts_membership&.code }
    }
  end

  def to_s(...)
    return super unless ts_managed?

    suffix = ActiveModel::Name::TsManaged::SUFFIX
    super.gsub(suffix, "#{suffix} - #{ts_log}")
  end

  def ts_destroy_values
    attributes
      .symbolize_keys
      .slice(*%i[id type ts_code group_id person_id start_on end_on])
      .merge(end_on: Time.zone.yesterday)
  end

  def ts_managed? = super && self.class.model_name.ts_role

  private

  def ts_interface = @ts_interface ||= Ts::Interface.new(self, nesting: person.ts_model)

  def ts_client = @ts_client ||= Ts::Client.new(ts_entity, nesting: person.ts_model)
end
