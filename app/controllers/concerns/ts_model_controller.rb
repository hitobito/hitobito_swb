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
    around_action :track_ts_model_changes, only: [:update]  # rubocop:disable Rails/LexicallyScopedActionFilter
  end

  private

  def track_ts_model_changes
    ts_model_before = entry.ts_model
    yield
    enqueue_ts_put if entry.ts_managed? && (entry.ts_model != ts_model_before)
  end

  def enqueue_ts_post(model = entry) = Ts::WriteJob.new(model.to_global_id, :post).enqueue!

  def enqueue_ts_put = Ts::WriteJob.new(entry.to_global_id, :put).enqueue!
end
