# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Ts
  class Log
    def initialize(ts_code, log_entry)
      @level = log_entry&.level || (ts_code ? :ok : :pending)
      @timestamp = log_entry&.created_at
    end

    def to_s
      [translated_status, formatted_datetime].compact_blank.join(" - ")
    end

    private

    attr_reader :level, :timestamp

    def translated_status = I18n.t("shared.ts_info.levels.#{level}")

    def formatted_datetime = (I18n.l(timestamp, format: :date_time_without_year) if timestamp)
  end
end
