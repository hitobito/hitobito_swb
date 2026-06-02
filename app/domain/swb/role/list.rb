# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Role::List
  extend ActiveSupport::Concern

  private

  def role_create(role)
    rescued do
      super.tap do |success|
        next unless success && role.ts_managed?

        if role.person.ts_code.present?
          Ts::WriteJob.new(role.to_global_id, :post).enqueue!
        else
          Ts::WriteJob.new(role.person.to_global_id, :post).enqueue!
          Ts::WriteJob.new(role.to_global_id, :post).enqueue!(run_at: 15.seconds.from_now)
        end
      end
    end
  end

  def role_destroy(role)
    rescued do
      super.tap do |success|
        next unless success && role.ts_managed?
        Ts::RoleDestroyJob.new(role.ts_destroy_values).enqueue!
      end
    end
  end

  def rescued
    yield
  rescue ActiveRecord::RecordInvalid
    counts[:failure] += 1 unless @skip_counts
    false
  end
end
