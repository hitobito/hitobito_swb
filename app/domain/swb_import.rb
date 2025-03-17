module SwbImport
  REGION_MAPPINGS = [
    [:Region_Abk, :short_name],
    [:Region_Name, :name],
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
    [:Club_Nr, :id, ->(v) { Integer(v) }],
    [:Club_Name, :name],
    [:"Parentnumber (Region)", :parent_short_name],
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
    ["Behindertensport", "Aktiv"],
    ["Center Contact", Group::Center::Kontakt],
    ["Club Ausbildung", Group::VereinKontakte::Kontakt],
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
end
