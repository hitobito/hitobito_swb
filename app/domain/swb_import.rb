# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module SwbImport
  CENTER_PARENT_NUMBER = "CENT"
  CENTER_ATTACHED_TO_SWB_PREFIX = "."

  REGION_MAPPINGS = [
    [:Code, :ts_code],
    [:Number, :short_name],
    [:Name, :name],
    [:Email, :email, :parse_email],
    [:Contact, :contact],
    [:Address, :street, :parse_street_from_address],
    [:Address, :housenumber, :parse_housenumber_from_address],
    [:Postalcode, :zip_code],
    [:City, :town],
    [:Phone, :phone, :parse_phone_number],
    [:Phone2, :phone2, :parse_phone_number],
    [:Mobile, :mobile, :parse_phone_number],
    [:Website, :website]
  ]

  CLUB_MAPPINGS = [
    [:Code, :ts_code],
    [:Number, :ts_club_number, ->(v) { Integer(v) }], # ist das wirklich
    [:Name, :name],
    [:Parentnumber, :parent_number],
    [:Contact, :contact],
    [:Address, :street, :parse_street_from_address],
    [:Address, :housenumber, :parse_housenumber_from_address],
    [:Postalcode, :zip_code],
    [:City, :town],
    [:Phone, :phone, :parse_phone_number],
    [:Phone2, :phone2, :parse_phone_number],
    [:Mobile, :mobile, :parse_phone_number],
    [:Website, :website]
  ]

  PERSON_MAPPINGS = [
    [:memberid, :id, ->(v) { Integer(v) }],
    [:code, :ts_code],
    [:firstname, :first_name],
    [:lastname, :last_name],
    [:gender, :gender, ->(v) { {f: :w}.fetch(v.downcase.to_sym, v.downcase) }],
    [:email, :email, :parse_email],
    [:dob, :birthday, :parse_date],
    [:address, :street, :parse_street_from_address],
    [:address, :housenumber, :parse_housenumber_from_address],
    [:postalcode, :zip_code],
    [:city, :town],
    [:country, :country, :parse_country],
    [:country, :nationality],
    [:country, :nationality_badminton],
    [:Language, :language, :parse_language],
    [:phone, :phone, :parse_phone_number],
    [:mobile, :mobile, :parse_phone_number]
  ]

  ROLE_MAPPINGS = [
    [:memberid, :person_id, ->(v) { Integer(v) }],
    [:groupcode, :groupcode],
    [:role, :role],
    [:TypeName, :spieler_role_type],
    [:startdate, :start_on, :parse_date],
    [:endate, :end_on, ->(v) { Date.parse(v) rescue nil unless v.starts_with?("9999") }] # rubocop:disable Style/RescueModifier
  ]

  ROLE_TYPE_MAPPING = [
    ["Club Ausbildung", Group::Verein::Ausbildung],
    ["Club Breitensport", Group::Verein::Breitensport],
    ["Club Ethik", Group::Verein::Ethik],
    ["Club Events/Turniere", Group::Verein::EventTurnier],
    ["Club Finanzen", Group::Verein::Finanzen],
    ["Club Interclub", Group::Verein::Interclub],
    ["Club J&S-Coach", Group::Verein::JSCoach],
    ["Club Kommunikation", Group::Verein::Kommunikation],
    ["Club Kontaktadresse", Group::VereinVorstand::Administrator],
    ["Club Leistungssport", Group::Verein::Leistungssport],
    ["Club Marketing/Sponsoring", Group::Verein::Marketing],
    ["Club Nachwuchs", Group::Verein::Nachwuchs],
    ["Club Nationalliga", Group::Verein::Nationalliga],
    ["Club Offical", Group::VereinKontakte::Kontakt],
    ["Club Präsident", [Group::VereinVorstand::Praesident, Group::Center::Direktion, Group::CenterUnaffilliated::Direktion]],
    ["Club Schiedsrichter", Group::Verein::Schiedsrichter],
    ["Club Sport Integrity", Group::Verein::Antidoping],
    ["Club Vize-Präsident", Group::VereinVorstand::Vizepraesident],
    ["Clubtrainer", Group::Verein::Clubtrainer],

    ["Region Breitensport", Group::Region::Breitensport],
    ["Region Finanzen", Group::Region::Finanzen],
    ["Region Interclub", Group::Region::Interclub],
    ["Region J&S-Coach", Group::Region::JSCoach],
    ["Region Kontaktadresse", Group::RegionKontakte::Kontakt],
    ["Region Marketing/Sponsoring", Group::Region::Marketing],
    ["Region Nachwuchs", Group::Region::Nachwuchs],
    ["Region Präsident", Group::RegionVorstand::Praesident],

    ["Center Contact", Group::Center::Direktion],

    ["Swiss Badminton Breitensport", Group::DachverbandGeschaeftsstelle::Breitensport],
    ["Swiss Badminton Interclub", Group::DachverbandGeschaeftsstelle::Interclub],
    ["Swiss Badminton J&S-Coach", Group::DachverbandGeschaeftsstelle::JSCoach],
    ["Swiss Badminton Kommunikation", Group::DachverbandGeschaeftsstelle::Kommunikation],
    ["Swiss Badminton Kontaktadresse", Group::DachverbandGeschaeftsstelle::Mitglied],
    ["Swiss Badminton Nachwuchs", Group::DachverbandGeschaeftsstelle::Nachwuchs],
    ["Swiss Badminton Präsident", Group::DachverbandVorstand::Praesident],

    ["Behindertensport", Group::DachverbandGeschaeftsstelle::Ethik],
    ["Ehemalige ZV-Mitglieder", Group::DachverbandKontakte::EhemaligesZvmitglied],
    ["Ehemaliger Mitarbeiter", Group::DachverbandKontakte::EhemaligerMitarbeiter],
    ["Ehrenmitglieder", Group::DachverbandKontakte::Ehrenmitglied],
    ["Nationalmannschaftstrainer", Group::DachverbandGeschaeftsstelle::Leistungssport],
    ["ZV-Mitglieder", Group::DachverbandKontakte::Kontakt],
    ["Turnierorganisator", Group::Verein::EventTurnier]
  ].to_h

  SPIELER_LIZENZ_MAPPING = [
    ["Aktiv", [Group::DachverbandSpieler::Aktivmitglied, Group::RegionSpieler::Aktivmitglied, Group::VereinSpieler::Aktivmitglied]],
    ["Passiv", [Group::DachverbandSpieler::Passivmitglied, Group::RegionSpieler::Passivmitglied, Group::VereinSpieler::Passivmitglied]],
    ["Junior (U17-U19)", [Group::DachverbandSpieler::JuniorU19, Group::RegionSpieler::JuniorU19, Group::VereinSpieler::JuniorU19]],
    ["Junior (up to U15)", [Group::DachverbandSpieler::JuniorU15, Group::RegionSpieler::JuniorU15, Group::VereinSpieler::JuniorU15]],

    ["Lizenz", Group::VereinSpieler::Lizenz],
    ["Lizenz NO ranking", Group::VereinSpieler::LizenzNoRanking],
    ["Vereinigungsspieler", Group::VereinSpieler::Vereinigungsspieler],
    ["Lizenz Plus", Group::VereinSpieler::LizenzPlus],
    ["Junior Lizenz Plus (U19)", Group::VereinSpieler::LizenzPlusJunior]
  ].to_h

  require_relative "swb_import/entity"
end
