# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Roles::Players
  class Promotion
    attr_reader :role_type, :max_date

    def initialize(role_type)
      @role_type = role_type
      @max_date = role_type.year_range.end.years.ago.beginning_of_year
    end

    def run
      roles.each do |role|
        promote(role)
      end
    end

    def roles = role_type.joins(:person).where(people: {birthday: [...max_date]})

    private

    def promote(role)
      Role.transaction do
        destroy_expired(role)
        new_role = create_new(role)
        create_log_entry(new_role, level: :info,
          message: "Promoted #{role} to #{new_role} for (#{role.person})")
      end
    rescue => exception
      create_log_entry(role, level: :error,
        message: "Failed to promote #{role} for (#{role.person})")
      Airbrake.notify(exception, parameters: role.attributes)
      Sentry.capture_exception(exception, logger: "delayed_job")
    end

    def destroy_expired(role)
      role.destroy!
      Ts::RoleDestroyJob.new(role.ts_destroy_values).enqueue!
    end

    def create_new(role)
      attrs = role.attributes.slice("person_id", "group_id")
      role_type_for(role).create!(attrs).tap do |role|
        Ts::WriteJob.new(role.to_global_id, :post).enqueue!
      end
    end

    def role_type_for(role)
      years = Time.zone.now.year - role.person.birthday.year
      type = Role::Player::JuniorU19.year_range.include?(years) ? "JuniorU19" : "Lizenz"
      [role.type.deconstantize, type].join("::").constantize
    end

    def create_log_entry(role, message:, level:)
      HitobitoLogEntry.create!(
        category: :promotion,
        subject: role,
        level:,
        message:
      )
    end
  end
end
