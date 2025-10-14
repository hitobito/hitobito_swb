# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
#
class Ts::Interface::LogEntry
  attr_reader :model, :operation, :exception, :method, :state

  MESSAGES = {
    get: {
      success: "Read %<model>s %<to_s>s (%<id>d, %<ts_code>s)",
      failed: "Reading failed for %<model>s (%<to_s>s %<id>d) - (%<error_code>s, %<error_message>s)"
    },
    post: {
      success: "Created %<model>s %<to_s>s (%<id>d, %<ts_code>s)",
      failed: "Create failed for %<model>s (%<to_s>s %<id>d) - (%<error_code>s, %<error_message>s)"
    },
    put: {
      success: "Updated %<model>s %<to_s>s (%<id>d, %<ts_code>s)",
      # rubocop:todo Layout/LineLength
      failed: "Update failed for %<model>s (%<to_s>s, %<id>d, %<ts_code>s) - (%<error_code>s, %<error_message>s)"
      # rubocop:enable Layout/LineLength
    }
  }

  def initialize(model, operation, exception = nil)
    @model = model
    @operation = operation
    @exception = exception
    @method = operation.request.method
    @state = operation.success? ? :success : :failed
  end

  def create!
    HitobitoLogEntry.create!(
      subject: model,
      category: :ts,
      level: operation.success? ? :info : :error,
      payload: operation.to_h,
      message: [exception_info,
        sprintf(MESSAGES.dig(method, state) % message_info)].compact_blank.join(" - ")
    )
  end

  def message_info
    {
      model: model.class.name, to_s: model.to_s, id: model.id, ts_code: model.ts_code,
      error_code: operation.response.error.code, error_message: operation.response.error.message
    }.compact_blank
  end

  def exception_info
    "#{exception} (#{exception.backtrace.first})" if @exception
  end
end
