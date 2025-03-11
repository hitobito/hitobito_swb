# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module SwbImport
  class Parser
    attr_reader :mappings, :attrs

    # Matches most but most likely not all
    STREET_LAST = /(.*?)\s(\d+\w*)/
    STREET_FIRST = /(\d+\w*),?\s(.*?)/

    def initialize(attrs, mappings)
      @attrs = attrs
      @mappings = mappings
    end

    def parse
      mappings.map do |source, target, conversion|
        value = attrs.fetch(source)

        [target, convert(value, conversion)]
      end.to_h
    end

    private

    def convert(value, conversion)
      return value unless conversion

      conversion.respond_to?(:call) ? conversion.call(value) : send(conversion, value)
    end

    def parse_email(v) = v&.downcase

    def parse_phone_number(v) = Phonelib.parse(v).sanitized

    def parse_country(v) = ISO3166::Country.find_country_by_ioc(v)&.alpha2&.downcase

    def parse_street_from_address(v) = v.to_s[STREET_FIRST, 2] || v.to_s[STREET_LAST, 1]

    def parse_housenumber_from_address(v) = v.to_s[STREET_FIRST, 1] || v.to_s[STREET_LAST, 2]

    def parse_date(v) = Date.parse(v) rescue nil # rubocop:disable Style/RescueModifier
  end
end
