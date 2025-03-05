# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module TsModelController
  extend ActiveSupport::Concern

  prepended do
    delegate :ts_managed?, :ts_params_changed?, to: :entry

    after_create :enqueue_ts_post, if: :ts_managed?
    after_update :enqueue_ts_put, if: :ts_params_changed?
  end

  private

  def enqueue_ts_post = Ts::WriteJob.new(entry.to_global_id, :post).enqueue!

  def enqueue_ts_put = Ts::WriteJob.new(entry.to_global_id, :put).enqueue!
end
