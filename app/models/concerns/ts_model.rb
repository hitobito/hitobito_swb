# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
#
module TsModel
  extend ActiveSupport::Concern

  prepended do
    class_attribute :ts_entity, :ts_mapping, :ts_path

    delegate :post, :get, :put, to: :ts_interface, prefix: true

    scope :with_ts_code, -> { where.not(ts_code: nil) }
    scope :without_ts_code, -> { where(ts_code: nil) }

    with_options class_name: "HitobitoLogEntry", as: :subject, inverse_of: :subject, dependent: :nullify do
      has_many :ts_logs
      has_one :ts_latest_log, -> { order(created_at: :desc) }
    end

    after_find :populate_ts_params, if: :responds_to_ts_code?
  end

  def ts_model = ts_entity.build(ts_params)

  def ts_log = Ts::Log.new(ts_latest_log)

  def ts_managed? = Ts::Config.exist?

  def ts_params_changed? = (@ts_params_from_db != ts_params) && ts_managed?

  private

  attr_reader :ts_params_from_db

  def ts_params
    ts_mapping
      .transform_values { |from| read_ts_value(from) }
      .to_h.compact_blank
  end

  def responds_to_ts_code? = respond_to?(:ts_code) # might not be set (e.g reduced people select for index)

  def read_ts_value(from) = from.is_a?(Proc) ? instance_exec(&from) : send(from)

  def ts_interface = @ts_interface ||= Ts::Interface.new(self)

  def populate_ts_params = @ts_params_from_db = ts_params
end
