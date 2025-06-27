# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
#
class Ts::Interface
  attr_reader :model, :nesting

  delegate :ts_model, to: :model

  def initialize(model, nesting: nil)
    @model = model
    @nesting = nesting
  end

  def post
    request(:post, ts_model.to_xml) do |response|
      model.update!(ts_code: response.entity.code) if response.success?
    end
  end

  def get
    fail "Need ts_code" unless ts_code?
    client.get(ts_model.code).entity
  end

  def put
    fail "Need ts_code" unless ts_code?
    fail "Need nested model ts_code" if nested? && nesting.code.blank?

    code = ts_model.code unless nested?
    request(:put, code, ts_model.to_xml)
  end

  private

  def ts_code? = model.ts_code.present?

  def nested? = @nesting.present?

  def request(method, *args)
    return mock_request(method, *args) unless Ts::Config.exist?

    operation = client.send(method, *args)
    ActiveRecord::Base.transaction do
      yield operation.response if block_given?
      LogEntry.new(model, operation).create!
    end

    operation
  rescue Ts::Client::Error => e
    LogEntry.new(model, e.operation).create!
  rescue StandardError => e
    LogEntry.new(model, operation, e).create!
  end

  def mock_request(method, *args)
    Rails.logger.info <<~TEXT.strip
      Ts::Config missing
      METHOD: #{method}
      #{args.join(", ")}
    TEXT
  end

  def client
    @client ||= Ts::Client.new(ts_model.class, nesting: nesting)
  end
end
