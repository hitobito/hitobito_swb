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

  # TODO:
  #  - update this list when TS -> Hitobito Role Mapping is finalized
  #  - clarify how integrate Spieler with Lizenz
  ROLE_MAPPINGS = [
    ["Group::DachverbandKontakte::Kontakt", "ZV-Mitglieder", "0E7C548F-07C6-4CC1-9305-EE8D087DE7E4"],
    ["Group::DachverbandMitglieder::JSCoach", "Swiss Badminton J&S-Coach", "48DFACCF-30FA-487E-83E6-1161083452F1"],
    ["Group::DachverbandVorstand::Praesident", "Swiss Badminton Präsident", "4C0A8178-035A-415B-933B-468A4A4CEDAE"],
    ["Group::RegionVorstand::Kassier", "Region Finanzen", "B9F99E0B-39E4-4666-BB17-99E6BC851E67"],
    ["Group::RegionVorstand::Praesident", "Region Präsident", "60C707B5-4020-44F0-8219-0349CC941342"],
    ["Group::RegionMitglieder::JSCoach", "Region J&S-Coach", "40216D41-2A6A-4A8A-B0F9-22ECD9A6FDCE"],
    ["Group::RegionKontakte::Kontakt", "Region Marketing/Sponsoring", "93F2CF0A-65D7-41EC-A7AE-BBA4034275D5"],
    ["Group::Center::Kontakt", "Center Contact", "0C0B745D-2AF3-409A-B1D8-4AE0F59D4C9A"],
    ["Group::VereinVorstand::Praesident", "Club Präsident", "B36EA231-DECD-47A5-B4D9-D1486EC7D964"],
    ["Group::VereinVorstand::Vizepraesident", "Club Vize-Präsident", "C090AE32-246B-49D8-8566-32ACF2075A59"],
    ["Group::VereinVorstand::Kassier", "Club Finanzen", "8DB2AD2B-62FA-4534-8777-FC7632F31A73"],
    ["Group::VereinMitglieder::Turnierorganisator", "Club Events/Turniere", "2E103842-C99D-49E9-90BE-690DBD411068"],
    ["Group::VereinMitglieder::JSCoach", "Club Kontaktadresse", "AE5822F4-DAFC-494F-BCD0-5FFE88C7B9DE"],
    ["Group::VereinMitglieder::Clubtrainer", "Clubtrainer", "F2D919E4-37B7-4E56-A205-0D77AA016DB1"],
    ["Group::VereinKontakte::Kontakt", "Club Sport Integrity", "E2E04F11-F1D5-4E85-A0A8-1C6ABABF9FBE"],
    ["Group::VereinKontakte::Adressverwaltung", "Club Kommunikation", "0D85785F-2DDF-4F6D-8547-81CFA3E1D22E"],
    ["Group::VereinMitglieder::Lizenz", "Spieler", "84B14141-A7C4-48ED-AA90-87009D79EEC2"],
    ["Group::VereinMitglieder::JuniorU15", "Spieler", "84B14141-A7C4-48ED-AA90-87009D79EEC2"],
    ["Group::VereinMitglieder::JuniorU19", "Spieler", "84B14141-A7C4-48ED-AA90-87009D79EEC2"],
    ["Group::VereinMitglieder::Vereinigungsspieler", "Spieler", "84B14141-A7C4-48ED-AA90-87009D79EEC2"],
    ["Group::VereinMitglieder::LizenzPlusJunior", "Spieler", "84B14141-A7C4-48ED-AA90-87009D79EEC2"],
    ["Group::VereinMitglieder::LizenzPlus", "Spieler", "84B14141-A7C4-48ED-AA90-87009D79EEC2"],
    ["Group::VereinMitglieder::Aktivmitglied", "Spieler", "84B14141-A7C4-48ED-AA90-87009D79EEC2"],
    ["Group::VereinMitglieder::Passivmitglied", "Spieler", "84B14141-A7C4-48ED-AA90-87009D79EEC2"],
    ["Group::VereinMitglieder::LizenzNoRanking", "Spieler", "84B14141-A7C4-48ED-AA90-87009D79EEC2"]
  ].map { |type, name, code| RoleMapping.new(type:, name:, code: code.downcase) }

  MEMBERSHIP_MAPPINGS = [
    ["Group::VereinMitglieder::Lizenz", "Lizenz", "ABCD4C8A-EAFE-44D3-A009-8AFBC8F34500"],
    ["Group::VereinMitglieder::JuniorU15", "Junior (up to U15)", "CD7C7A2A-FC87-4923-858A-3C511780CE58"],
    ["Group::VereinMitglieder::JuniorU19", "Junior (U17-U19)", "EDF0BD4C-C38C-4985-A979-655720B8CFC4"],
    ["Group::VereinMitglieder::Vereinigungsspieler", "Vereinigungsspieler", "0DA65EB5-A0F9-4020-A89F-9A678B8193A9"],
    ["Group::VereinMitglieder::LizenzPlusJunior", "Junior Lizenz Plus (U19)", "8BC7ACFC-1615-45DA-BE1C-AE3521E1DF0A"],
    ["Group::VereinMitglieder::LizenzPlus", "Lizenz Plus", "7D47DF1C-70FE-48DB-94C0-D91F32A5FF1B"],
    ["Group::VereinMitglieder::Aktivmitglied", "Aktiv", "313EDDCF-8F18-4254-83B6-45E0E2596506"],
    ["Group::VereinMitglieder::Passivmitglied", "Passiv", "3F982B6D-612B-4924-9438-911492F9BF3A"],
    ["Group::VereinMitglieder::LizenzNoRanking", "Lizenz NO ranking", "2F469D0A-6ACC-4B53-9CC8-B1B74F3B8D07"]
  ].map { |type, name, code| RoleMapping.new(type:, name:, code: code.downcase) }
end
