# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Ts::Client
  CONTENT_TYPE = "text/xml"
  SUCCESS_CODES = (200..299)
  UNEXPECTED_STATUS_CODE = "Unexpected status code: %<code>d"

  Error = Class.new(StandardError) do
    attr_reader :operation

    def initialize(message, operation)
      super(message)
      @operation = operation
    end
  end

  Operation = Data.define(:request, :response) do
    delegate :entity, :error, :success?, to: :response, allow_nil: true

    def to_h = {request: request.to_h, response: response.to_h}
  end
  Request = Data.define(:method, :url, :body)

  delegate :host, :username, :password, :organization, to: "Ts::Config"

  attr_reader :entity, :nesting

  def initialize(entity, nesting: nil)
    @entity = entity
    @nesting = nesting
  end

  def list
    request(:get, build_url)
  end

  def post(payload)
    request(:post, build_url, payload)
  end

  def get(code)
    request(:get, build_url(code))
  end

  def put(code, payload)
    request(:put, build_url(code), payload)
  end

  private

  def request(method, url, payload = nil)
    request = Request.new(method, url, payload)
    response = RestClient.send(method, url, *[payload, options].compact)
    Operation.new(request:, response: Response.new(entity, response)).tap do |operation|
      next if SUCCESS_CODES.include?(response.code)
      raise Error.new(sprintf(UNEXPECTED_STATUS_CODE % response.code), operation)
    end
  rescue RestClient::Exception => e
    raise Error.new(e.message, Operation.new(request:, response: Response.new(entity, e.response)))
  end

  def build_url(code = nil) = (base_path + [code]).compact_blank.join("/")

  def base_path
    base = ["#{host}/1.0/Organization", organization]
    base += [nesting.class.path_name, nesting.code] if nesting
    base + [entity.path_name]
  end

  def auth_credentials = Base64.strict_encode64("#{username}:#{password}")

  def options = {content_type: CONTENT_TYPE, authorization: "Basic #{auth_credentials}"}
end
