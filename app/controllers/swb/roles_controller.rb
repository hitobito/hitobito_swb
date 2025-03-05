# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
#
module Swb::RolesController
  extend ActiveSupport::Concern

  private

  def enqueue_ts_put
    return super if entry.person.ts_code.present?

    Ts::WriteJob.new(entry.person.to_global_id, :post).enqueue!
    Ts::WriteJob.new(entry.to_global_id, :put).enqueue!(run_at: 15.seconds.from_now)
  end

  def enqueue_ts_post
    return super if entry.person.ts_code.present?

    Ts::WriteJob.new(entry.person.to_global_id, :post).enqueue!
    Ts::WriteJob.new(entry.to_global_id, :post).enqueue!(run_at: 15.seconds.from_now)
  end
end
