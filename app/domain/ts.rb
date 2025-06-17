# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Ts
  GENDERS = %w[m w].zip([1, 2]).to_h

  CENTER_PARENT_CODE = "140D8B65-3AEC-4CF9-A869-EFD008D5AF1B" # centers are not imported

  COUNTRIES = ISO3166::Country.all.map { |c| [c.alpha2, c.ioc] if c.ioc }.compact_blank.to_h

  RoleMapping = Data.define(:type, :name, :code)

  ROLE_CODE_MAPPING = [
    ["Spieler", "84b14141-A7C4-48ED-AA90-87009D79EEC2"],
    ["Swiss Badminton Interclub", "3EBE4B1C-274F-43C2-97ED-193CD93C414C"],
    ["Club Interclub", "A6DC0AB7-4904-4C39-901A-2D327941C0FF"],
    ["Region Interclub", "D1E0E7EB-293F-455F-93D0-F5C02615A42F"],
    ["Clubtrainer", "F2D919E4-37B7-4E56-A205-0D77AA016DB1"]
  ]

  MEMBERSHIP_CODE_MAPPING = [
    ["Aktiv", "313EDDCF-8F18-4254-83B6-45E0E2596506"],
    ["Passiv", "3F982B6D-612B-4924-9438-911492F9BF3A"],
    ["Lizenz", "ABCD4C8A-EAFE-44D3-A009-8AFBC8F34500"],
    ["Junior (up to U15)", "CD7C7A2A-FC87-4923-858A-3C511780CE58"],
    ["Junior (U17-U19)", "EDF0BD4C-C38C-4985-A979-655720B8CFC4"],
    ["Vereinigungsspieler", "0DA65EB5-A0F9-4020-A89F-9A678B8193A9"],
    ["Junior Lizenz Plus (U19)", "8BC7ACFC-1615-45DA-BE1C-AE3521E1DF0A"],
    ["Lizenz Plus", "7D47DF1C-70FE-48DB-94C0-D91F32A5FF1B"],
    ["Lizenz NO ranking", "2F469D0A-6ACC-4B53-9CC8-B1B74F3B8D07"]
  ]

  ROLE_MAPPINGS = ROLE_CODE_MAPPING.flat_map do |name, code|
    if name == "Spieler"
      next SwbImport::SPIELER_LIZENZ_MAPPING.map(&:second).flatten.map do |type|
        RoleMapping.new(type:, name:, code:)
      end
    end

    Array(SwbImport::ROLE_TYPE_MAPPING.fetch(name)).map do |type|
      RoleMapping.new(type:, name:, code: code.downcase)
    end
  end

  MEMBERSHIP_MAPPINGS = MEMBERSHIP_CODE_MAPPING.flat_map do |name, code|
    Array(SwbImport::SPIELER_LIZENZ_MAPPING.fetch(name)).map do |type|
      RoleMapping.new(type:, name:, code: code.downcase)
    end
  end
end
