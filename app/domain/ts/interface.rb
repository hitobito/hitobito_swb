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

  def get
    client.get(ts_model.code).entity
  end

  def put
    request(:put, ts_model.code, ts_model.to_xml)
  end

  def post
    request(:post, ts_model.to_xml) do |response|
      model.update!(ts_code: response.entity.code) if response.success?
    end
  end

  def delete
    request(:delete, ts_model.code)
  end

  private

  def request(method, *args)
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

  def client
    @client ||= Ts::Client.new(ts_model.class, nesting: nesting)
  end
end
