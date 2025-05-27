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
    COUNTRY_MAPPING = {
      "ENG" => "GBR",
      "UK" => "GBR",
      "SCO" => "GBR",
      "IMN" => "GBR", # Isle of Man?
      "ZAI" => "COD", # Zaire now Congo?
      "GUF" => "FRA" # French Guiana?
    }.freeze

    LANGUAGES = [
      [:de, /Deutsch/i],
      [:fr, /Französisch/i],
      [:it, /Italienisch/i]
    ].to_h.invert

    def initialize(attrs, mappings)
      @attrs = attrs
      @mappings = mappings
    end

    def parse
      mappings.map do |source, target, conversion|
        value = attrs.fetch(source)

        [target, convert(value, conversion).presence]
      end.to_h
    end

    private

    def convert(value, conversion)
      return value unless conversion

      conversion.respond_to?(:call) ? conversion.call(value) : send(conversion, value)
    end

    def parse_email(v) = Truemail.validate(v.to_s.downcase.delete(" ").gsub("(at)", "@"), with: :regex)
      .result.then { |r| r.email if r.success }

    def parse_phone_number(v) = Phonelib.parse(v).then { |n| n.international if n.valid? }

    def parse_country(v) = ISO3166::Country.find_country_by_ioc(COUNTRY_MAPPING.fetch(v, v))&.alpha2

    def parse_language(v) = LANGUAGES.find { |regex, val| regex.match?(v) }&.second || :de

    def parse_street_from_address(v) = v.to_s[STREET_FIRST, 2] || v.to_s[STREET_LAST, 1]

    def parse_housenumber_from_address(v) = v.to_s[STREET_FIRST, 1] || v.to_s[STREET_LAST, 2]

    def parse_date(v) = Date.parse(v) rescue nil # rubocop:disable Style/RescueModifier

    def parse_ts_club_number(v)
      @@club_numbers ||= Group.where.not(ts_club_number: nil).pluck(:ts_club_number, :id).to_h.stringify_keys
      @@club_numbers[v]
    end
  end
end
