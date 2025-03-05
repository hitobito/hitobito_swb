# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Ts::Client::Response
  attr_reader :entity_class, :code, :xml

  def initialize(entity_class, http_response)
    @entity_class = entity_class
    @xml = Nokogiri::XML(http_response.body)
    @code = http_response.code
  end

  def entities = from_xml(xml, entity_class)

  def entity = entities.first

  def success? = error.nil? || error.success?

  def error = from_xml(xml, Ts::Entity::Error)[0]

  def to_h
    {code:, xml: xml.to_s, message: error&.message}.compact_blank
  end

  private

  def from_xml(xml, entity_class)
    xml.xpath("//#{entity_class.element_name}").map do |element|
      entity_class.from_xml(element.to_s)
    end
  end
end
