# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
#
module Swb::RolesController
  extend ActiveSupport::Concern

  prepended do
    helper_method :force_start_on_today?
    before_render_new :populate_person_phone_numbers
    before_action :set_admin
    after_destroy :enqueue_ts_delete, if: -> { entry.ts_code }
  end

  private

  def populate_person_phone_numbers
    entry.person.phone_numbers.build(label: :mobile) if entry.person.phone_numbers.none?
  end

  def build_new_type
    super.tap do |role|
      role.start_on = Time.zone.today if force_start_on_today?(role)
    end
  end

  def create_new_role_and_destroy_old_role
    super.tap do |success|
      next unless success
      @role_change = true

      enqueue_ts_post(@new_role) if @new_role.ts_managed?
      enqueue_ts_delete(entry) if entry.ts_managed?
    end
  end

  def enqueue_ts_put
    return if @role_change
    return super if entry.person.ts_code.present?

    Ts::WriteJob.new(entry.person.to_global_id, :post).enqueue!
    Ts::WriteJob.new(entry.to_global_id, :put).enqueue!(run_at: 15.seconds.from_now)
  end

  def enqueue_ts_post(model = entry)
    return super if model.person.ts_code.present?

    Ts::WriteJob.new(model.person.to_global_id, :post).enqueue!
    Ts::WriteJob.new(model.to_global_id, :post).enqueue!(run_at: 15.seconds.from_now)
  end

  def enqueue_ts_delete(model = entry)
    Ts::RoleDestroyJob.new(model.ts_destroy_values).enqueue!
  end

  def force_start_on_today?(role) = role.ts_managed? && !Current.admin

  def set_admin = Current.admin = current_ability.user_context.admin || current_user.root?
end
