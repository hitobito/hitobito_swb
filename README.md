# Hitobito SWB

This hitobito wagon defines the organization hierarchy with groups and roles
of Swiss Badminton.

## Additional Features

- Updates certain Person, Groups and Roles to [TournamentSoftware](https://www.tournamentsoftware.com/)

## SWB Organization Hierarchy

<!-- roles:start -->
    * Dachverband
      * Dachverband
        * Administrator:in: [:admin, :layer_and_below_full, :impersonation]  --  (Group::Dachverband::Administrator)
      * Vorstand
        * Präsident:in (TS): [:layer_full, :contact_data]  --  (Group::DachverbandVorstand::Praesident)
        * Vizepräsident:in: [:layer_full, :contact_data]  --  (Group::DachverbandVorstand::Vizepraesident)
        * Vorstandsmitglied: [:layer_full, :contact_data]  --  (Group::DachverbandVorstand::Vorstandsmitglied)
      * Geschäftsstelle
        * Geschäftsführer:in: [:layer_and_below_full, :admin, :contact_data, :approve_applications, :finance]  --  (Group::DachverbandGeschaeftsstelle::Geschaeftsfuehrer)
        * Kassier:in: [:layer_and_below_full, :contact_data, :finance]  --  (Group::DachverbandGeschaeftsstelle::Kassier)
        * Mitglied: [:layer_and_below_full, :contact_data, :approve_applications]  --  (Group::DachverbandGeschaeftsstelle::Mitglied)
      * Gremium/Projektgruppe
        * Leiter:in: [:group_and_below_full, :contact_data]  --  (Group::DachverbandGremium::Leitung)
        * Mitglied: [:group_and_below_read]  --  (Group::DachverbandGremium::Mitglied)
      * Mitglieder
        * Aktivmitglied: []  --  (Group::DachverbandMitglieder::Aktivmitglied)
        * Passivmitglied: []  --  (Group::DachverbandMitglieder::Passivmitglied)
        * Junior:in (bis U-15): []  --  (Group::DachverbandMitglieder::JuniorU15)
        * Junior:in (U17-U19): []  --  (Group::DachverbandMitglieder::JuniorU19)
        * Lizenz: []  --  (Group::DachverbandMitglieder::Lizenz)
        * Vereinigungsspieler:in: []  --  (Group::DachverbandMitglieder::Vereinigungsspieler)
        * Lizenz Plus Junior:in (U19): []  --  (Group::DachverbandMitglieder::LizenzPlusJunior)
        * Lizenz Plus: []  --  (Group::DachverbandMitglieder::LizenzPlus)
        * Shuttletime: []  --  (Group::DachverbandMitglieder::Shuttletime)
        * Lizenz NO ranking: []  --  (Group::DachverbandMitglieder::LizenzNoRanking)
        * J&S Coach (TS): [:group_read]  --  (Group::DachverbandMitglieder::JSCoach)
      * Kontakte
        * Kontakt (TS): []  --  (Group::DachverbandKontakte::Kontakt)
    * Region
      * Region
        * Administrator:in: [:layer_and_below_full, :contact_data, :finance]  --  (Group::Region::Administrator)
      * Vorstand
        * Präsident:in (TS): [:layer_full, :contact_data]  --  (Group::RegionVorstand::Praesident)
        * Vizepräsident:in: [:layer_full, :contact_data]  --  (Group::RegionVorstand::Vizepraesident)
        * Kassier:in (TS): [:layer_read, :contact_data, :finance]  --  (Group::RegionVorstand::Kassier)
        * Vorstandsmitglied: [:layer_full, :contact_data]  --  (Group::RegionVorstand::Vorstandsmitglied)
      * Mitglieder
        * Aktivmitglied: []  --  (Group::RegionMitglieder::Aktivmitglied)
        * Passivmitglied: []  --  (Group::RegionMitglieder::Passivmitglied)
        * Junior:in (bis U-15): []  --  (Group::RegionMitglieder::JuniorU15)
        * Junior:in (U17-U19): []  --  (Group::RegionMitglieder::JuniorU19)
        * Lizenz: []  --  (Group::RegionMitglieder::Lizenz)
        * Vereinigungsspieler:in: []  --  (Group::RegionMitglieder::Vereinigungsspieler)
        * Lizenz Plus Junior:innen (U19): []  --  (Group::RegionMitglieder::LizenzPlusJunior)
        * Lizenz Plus: []  --  (Group::RegionMitglieder::LizenzPlus)
        * Shuttletime: []  --  (Group::RegionMitglieder::Shuttletime)
        * Lizenz NO ranking: []  --  (Group::RegionMitglieder::LizenzNoRanking)
        * J&S Coach (TS): [:group_read]  --  (Group::RegionMitglieder::JSCoach)
      * Kontakte
        * Adressverwalter:in: [:group_and_below_full]  --  (Group::RegionKontakte::Adressverwaltung)
        * Kontakt (TS): []  --  (Group::RegionKontakte::Kontakt)
    * Verein
      * Verein
        * Administrator:in: [:layer_and_below_full, :contact_data]  --  (Group::Verein::Administrator)
        * Adressverwalter:in: [:group_and_below_full]  --  (Group::Verein::Adressverwaltung)
        * Leiter:in: [:group_and_below_full, :contact_data]  --  (Group::Verein::Leitung)
        * Aktivmitglied: [:group_and_below_read]  --  (Group::Verein::Aktivmitglied)
      * Vorstand
        * Präsident:in (TS): [:layer_full, :contact_data]  --  (Group::VereinVorstand::Praesident)
        * Vizepräsident:in (TS): [:layer_full, :contact_data]  --  (Group::VereinVorstand::Vizepraesident)
        * Kassier:in (TS): [:layer_read, :contact_data, :finance]  --  (Group::VereinVorstand::Kassier)
        * Vorstandsmitglied: [:layer_full, :contact_data]  --  (Group::VereinVorstand::Vorstandsmitglied)
      * Mitglieder
        * Aktivmitglied (TS): []  --  (Group::VereinMitglieder::Aktivmitglied)
        * Passivmitglied (TS): []  --  (Group::VereinMitglieder::Passivmitglied)
        * Junior:in (bis U-15) (TS): []  --  (Group::VereinMitglieder::JuniorU15)
        * Junior:in (U17-U19) (TS): []  --  (Group::VereinMitglieder::JuniorU19)
        * Lizenz (TS): []  --  (Group::VereinMitglieder::Lizenz)
        * Clubtrainer:in (TS): []  --  (Group::VereinMitglieder::Clubtrainer)
        * Ehrenmitglied: []  --  (Group::VereinMitglieder::Ehrenmitglied)
        * J&S Expert:in: []  --  (Group::VereinMitglieder::JSExperte)
        * Kaderspieler:in: []  --  (Group::VereinMitglieder::Kaderspieler)
        * Turnierorganisator:in (TS): []  --  (Group::VereinMitglieder::Turnierorganisator)
        * Volunteer: []  --  (Group::VereinMitglieder::Volunteer)
        * ZV-Mitglied: []  --  (Group::VereinMitglieder::ZVMitglied)
        * Vereinigungsspieler:in (TS): []  --  (Group::VereinMitglieder::Vereinigungsspieler)
        * Lizenz Plus Junior:innen (U19) (TS): []  --  (Group::VereinMitglieder::LizenzPlusJunior)
        * Lizenz Plus (TS): []  --  (Group::VereinMitglieder::LizenzPlus)
        * Shuttletime: []  --  (Group::VereinMitglieder::Shuttletime)
        * Lizenz NO ranking (TS): []  --  (Group::VereinMitglieder::LizenzNoRanking)
        * J&S Coach (TS): [:group_read]  --  (Group::VereinMitglieder::JSCoach)
      * Kontakte
        * Adressverwalter:in (TS): [:group_and_below_full]  --  (Group::VereinKontakte::Adressverwaltung)
        * Kontakt (TS): []  --  (Group::VereinKontakte::Kontakt)
    * Center
      * Center
        * Administrator:in: [:layer_and_below_full, :contact_data, :finance]  --  (Group::Center::Administrator)
        * Kontakt (TS): []  --  (Group::Center::Kontakt)
(Output of rake app:hitobito:roles)
<!-- roles:end -->
