# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
#
module Swb::RolesController
  extend ActiveSupport::Concern

  prepended do
    after_destroy :enqueue_ts_delete, if: -> { entry.ts_code }
  end

  private

  # braucht viele tests, wann das wirklich wie enqueued werden soll
  def create_new_role_and_destroy_old_role
    super.tap do |success|
      next unless success

      enqueue_ts_post(@new_role) if @new_role.ts_managed?
      enqueue_ts_delete(entry) if entry.ts_managed?
    end
  end

  def enqueue_ts_put
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
end
