# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Ts::Client::Response
  attr_reader :entity_class, :code, :xml

  HTTP_STATUS_CODES = Rack::Utils::HTTP_STATUS_CODES

  def initialize(entity_class, http_response)
    @entity_class = entity_class
    @xml = Nokogiri::XML(http_response.body)
    @code = http_response.code
  end

  def entities = from_xml(xml, entity_class)

  def entity = entities.first

  def error = build_error

  def success? = error.nil? || error.success?

  def to_h
    {code:, xml: xml.to_s, message: error&.message}.compact_blank
  end

  private

  def from_xml(xml, entity_class, clear_whitespace: false)
    xml.xpath("//#{entity_class.element_name}").map do |element|
      entity_class.from_xml(element.to_s, clear_whitespace:)
    end
  end

  def build_error
    return Ts::Entity::Error.new(code, HTTP_STATUS_CODES[code]) unless http_success?

    from_xml(xml, Ts::Entity::Error, clear_whitespace: true)[0]
  end

  def http_success? = code == 200
end
