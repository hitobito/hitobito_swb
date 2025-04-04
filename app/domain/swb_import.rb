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
    [:Number, :id, ->(v) { Integer(v) }],
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
    [:groupnumber, :groupnumber],
    [:role, :role],
    [:TypeName, :spieler_role_type],
    [:startdate, :start_on, :parse_date],
    [:endate, :end_on, ->(v) { Date.parse(v) rescue nil unless v.starts_with?("9999") }] # rubocop:disable Style/RescueModifier
  ]

  # For mapping specific role types
  ROLE_TYPE_MAPPING = [
    ["", ""],
    ["Behindertensport", "Aktiv"],  # 1 auf SB
    ["Center Contact", Group::Center::Kontakt], # 11 auf VereinsEbene ( zb. BC Thun)
    ["Club Ausbildung", Group::VereinKontakte::Kontakt], # 111 auf Vereinsebenen ->
    ["Club Breitensport", Group::VereinKontakte::Kontakt],
    ["Club Ethik", Group::VereinKontakte::Kontakt],
    ["Club Events/Turniere", Group::VereinMitglieder::Turnierorganisator],
    ["Club Finanzen", Group::VereinVorstand::Kassier],
    ["Club Interclub", Group::VereinKontakte::Kontakt],
    ["Club J&S-Coach", Group::VereinMitglieder::JSCoach],
    ["Club Kommunikation", Group::VereinKontakte::Adressverwaltung],
    ["Club Kontaktadresse", Group::VereinMitglieder::JSCoach],
    ["Club Leistungssport", Group::VereinKontakte::Kontakt],
    ["Club Marketing/Sponsoring", Group::VereinKontakte::Kontakt],
    ["Club Nachwuchs", Group::VereinKontakte::Kontakt],
    ["Club Nationalliga", Group::VereinKontakte::Kontakt],
    ["Club Offical", Group::VereinKontakte::Kontakt],
    ["Club Präsident", Group::VereinVorstand::Praesident],
    ["Club Schiedsrichter", Group::VereinKontakte::Kontakt],
    ["Club Sport Integrity", Group::VereinKontakte::Kontakt],

    ["Club Vize-Präsident", Group::VereinVorstand::Vizepraesident],
    ["Clubtrainer", Group::VereinMitglieder::Clubtrainer],
    # ["Ehemalige ZV-Mitglieder", ""],
    # ["Ehemaliger Mitarbeiter", ""],
    # ["Ehrenmitglieder", "Passiv"],
    # ["Nationalmannschaftstrainer", ""],
    ["Region Breitensport", Group::RegionKontakte::Kontakt],
    ["Region Finanzen", Group::RegionVorstand::Kassier],
    ["Region Interclub", Group::RegionKontakte::Kontakt],
    ["Region J&S-Coach", Group::RegionMitglieder::JSCoach],
    ["Region Kontaktadresse", Group::RegionKontakte::Kontakt],
    ["Region Marketing/Sponsoring", Group::RegionKontakte::Kontakt],
    # ["Region Nachwuchs", Group::RegionVorstand::Administration],
    ["Region Präsident", Group::RegionVorstand::Praesident],
    ["Swiss Badminton Breitensport", Group::DachverbandKontakte::Kontakt],
    ["Swiss Badminton Interclub", Group::DachverbandKontakte::Kontakt],
    ["Swiss Badminton J&S-Coach", Group::DachverbandMitglieder::JSCoach],
    ["Swiss Badminton Kommunikation", Group::DachverbandKontakte::Kontakt],
    ["Swiss Badminton Kontaktadresse", Group::DachverbandKontakte::Kontakt],
    ["Swiss Badminton Nachwuchs", Group::DachverbandKontakte::Kontakt],
    ["Swiss Badminton Präsident", Group::DachverbandVorstand::Praesident],
    ["Turnierorganisator", Group::DachverbandKontakte::Kontakt],
    ["ZV-Mitglieder", Group::DachverbandKontakte::Kontakt]
  ].to_h

  SPIELER_LIZENZ_MAPPING = [
    ["Junior (U17-U19)", Group::VereinMitglieder::JuniorU19],
    ["Lizenz", Group::VereinMitglieder::Lizenz],
    ["Passiv", Group::VereinMitglieder::Passivmitglied],
    ["Aktiv", Group::VereinMitglieder::Aktivmitglied],
    ["Junior (up to U15)", Group::VereinMitglieder::JuniorU15],
    ["Lizenz NO ranking", Group::VereinMitglieder::LizenzNoRanking],
    ["Vereinigungsspieler", Group::VereinMitglieder::Vereinigungsspieler],
    ["Lizenz Plus", Group::VereinMitglieder::LizenzPlus],
    ["Junior Lizenz Plus (U19)", Group::VereinMitglieder::LizenzPlusJunior]
  ].to_h

  require_relative "swb_import/entity"

  Mitglied = Data.define(:role, :type_name, :groupname)

  class InfoGenerator
    def initialize(key = "mitglieder-short")
      @csv = SwbImport::Csv.new(key).csv
      @mitglieder = read_mitglieder
    end

    def write
      File.write("ts_hitobito_roles.csv", generate)
    end

    def generate
      by_role = @mitglieder.group_by(&:role).sort_by { |k, v| v.size }.reverse
      group_names = @mitglieder.map(&:groupname).tally.sort_by(&:second).reverse.map(&:first)
      binding.pry
      @headers = ["TS Rolle", "TS Typ", "Total", "Rolle Hitobito", "Total Gruppen", *group_names]
      rows = CSV.generate do |csv|
        csv << @headers
        by_role.each do |role, mitglieder|
          if mitglieder.map(&:type_name).empty?
            csv << add_row(role, mitglieder, ROLE_MAPPING[role])
          else
            mitglieder.group_by(&:type_name).each do |type_name, mitglieder|
              csv << add_row(role, mitglieder, type_name:)
            end
          end
        end
      end
    end

    def add_row(role, mitglieder, type_name: nil)
      hitobito_role = type_name.present? ? SPIELER_LIZENZ_MAPPING[type_name] : ROLE_TYPE_MAPPING[role]
      group_names = mitglieder.map(&:groupname)
      [role, hitobito_role, mitglieder.size, hitobito_role, group_names.uniq.count].tap do |row|
        group_names.tally.each do |group_name, count|
          pos = @headers.index(group_name)
          row[pos] = count
        end
      end
    end

    def read_mitglieder
      @csv.map do |r|
        attrs = r.to_h.transform_keys { |k| k.underscore.to_sym }.slice(*Mitglied.members)
        Mitglied.new(**attrs)
      end
    end
  end
end
