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
        * Vorstandsmitglied: [:layer_full, :contact_data]  --  (Group::DachverbandVorstand::Mitglied)
      * Geschäftsstelle
        * Geschäftsführer:in: [:layer_and_below_full, :admin, :contact_data, :approve_applications]  --  (Group::DachverbandGeschaeftsstelle::Geschaeftsfuehrer)
        * Mitglied: [:group_read]  --  (Group::DachverbandGeschaeftsstelle::Mitglied)
        * J&S Coach (TS): [:group_read]  --  (Group::DachverbandGeschaeftsstelle::JSCoach)
        * Interclub: [:layer_and_below_full, :contact_data, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Interclub)
        * Event/Turnier: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::EventTurnier)
        * Beauftragte:r Ethik: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::BeauftragterEthik)
        * Umfeldmanager:in: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Umfeldmanager)
        * Chef:in Ausbildung: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::ChefAusbildung)
        * Chef:in Breitensport: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::ChefBreitensport)
        * Chef:in Leistungssport: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::ChefLeistungssport)
        * Chef:in Nachwuchs: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::ChefNachwuchs)
        * Verantwortliche:r Antidoping: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::VerantwortungAntidoping)
        * Verantwortliche:r Club Management: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::VerantwortungClubmanagement)
        * Verantwortliche:r Finanzen: [:layer_and_below_full, :impersonation, :finance]  --  (Group::DachverbandGeschaeftsstelle::VerantwortungFinanzen)
        * Verantwortliche:r Kommunikation: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::VerantwortungKommunikation)
        * Verantwortliche:r Marketing: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::VerantwortungMarketing)
        * Verantwortliche:r Medical: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::VerantwortungMedical)
        * Verantwortliche:r Personal: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::VerantwortungPersonal)
      * Kommission
        * Leiter:in: [:group_full]  --  (Group::DachverbandKommission::Leitung)
        * Mitglied: [:group_read]  --  (Group::DachverbandKommission::Mitglied)
      * Kader
        * Trainer:in: [:group_read]  --  (Group::DachverbandKader::Trainer)
        * Athlet:in: [:group_read]  --  (Group::DachverbandKader::Athlet)
      * Spieler
        * Aktivmitglied: []  --  (Group::DachverbandSpieler::Aktivmitglied)
        * Passivmitglied: []  --  (Group::DachverbandSpieler::Passivmitglied)
        * Junior:in (bis U-15): []  --  (Group::DachverbandSpieler::JuniorU15)
        * Junior:in (U17-U19): []  --  (Group::DachverbandSpieler::JuniorU19)
        * Lizenz: []  --  (Group::DachverbandSpieler::Lizenz)
      * Technisch / Offiziell
        * Linienrichter:in: [:group_read]  --  (Group::DachverbandTechnischoffiziell::Linienrichter)
        * Referee: [:group_read]  --  (Group::DachverbandTechnischoffiziell::Referee)
        * Schiedsrichter:in: [:group_read]  --  (Group::DachverbandTechnischoffiziell::Schiedsrichter)
      * Kontakte
        * Kontakt (TS): []  --  (Group::DachverbandKontakte::Kontakt)
        * Ehemaliges ZV-Mitglied: []  --  (Group::DachverbandKontakte::EhemaligesZvmitglied)
        * Ehemalige:r Mitarbeiter:in: []  --  (Group::DachverbandKontakte::EhemaligerMitarbeiter)
        * Ehrenmitglied: []  --  (Group::DachverbandKontakte::Ehrenmitglied)
        * Shuttletime-Tutor: []  --  (Group::DachverbandKontakte::ShuttletimeTutor)
        * Gönner:in: []  --  (Group::DachverbandKontakte::Goenner)
        * Medien: []  --  (Group::DachverbandKontakte::Medien)
        * Partner: []  --  (Group::DachverbandKontakte::Partner)
        * J&S Expert:in: []  --  (Group::DachverbandKontakte::JSExperte)
    * Region
      * Region
        * J&S Coach (TS): [:group_read]  --  (Group::Region::JSCoach)
        * Interclub: [:layer_and_below_full]  --  (Group::Region::Interclub)
        * Event/Turnier: [:group_read]  --  (Group::Region::EventTurnier)
        * Beauftragte:r Ethik: [:group_read]  --  (Group::Region::BeauftragterEthik)
        * Umfeldmanager:in: [:group_read]  --  (Group::Region::Umfeldmanager)
        * Chef:in Ausbildung: [:group_read]  --  (Group::Region::ChefAusbildung)
        * Chef:in Breitensport: [:group_read]  --  (Group::Region::ChefBreitensport)
        * Chef:in Leistungssport: [:group_read]  --  (Group::Region::ChefLeistungssport)
        * Chef:in Nachwuchs: [:group_read]  --  (Group::Region::ChefNachwuchs)
        * Verantwortliche:r Antidoping: [:group_read]  --  (Group::Region::VerantwortungAntidoping)
        * Verantwortliche:r Club Management: [:group_read]  --  (Group::Region::VerantwortungClubmanagement)
        * Verantwortliche:r Finanzen: [:group_read]  --  (Group::Region::VerantwortungFinanzen)
        * Verantwortliche:r Kommunikation: [:group_read]  --  (Group::Region::VerantwortungKommunikation)
        * Verantwortliche:r Marketing: [:group_read]  --  (Group::Region::VerantwortungMarketing)
        * Verantwortliche:r Medical: [:group_read]  --  (Group::Region::VerantwortungMedical)
        * Verantwortliche:r Personal: [:group_read]  --  (Group::Region::VerantwortungPersonal)
      * Vorstand
        * Präsident:in (TS): [:layer_and_below_read]  --  (Group::RegionVorstand::Praesident)
        * Vizepräsident:in: [:layer_and_below_read]  --  (Group::RegionVorstand::Vizepraesident)
        * Sekretär:in: [:layer_and_below_full]  --  (Group::RegionVorstand::Sekretaer)
        * Kassier:in (TS): [:layer_and_below_read, :finance]  --  (Group::RegionVorstand::Kassier)
        * Vorstandsmitglied: [:layer_and_below_read]  --  (Group::RegionVorstand::Mitglied)
      * Spieler
        * Aktivmitglied: []  --  (Group::RegionSpieler::Aktivmitglied)
        * Passivmitglied: []  --  (Group::RegionSpieler::Passivmitglied)
        * Junior:in (bis U-15): []  --  (Group::RegionSpieler::JuniorU15)
        * Junior:in (U17-U19): []  --  (Group::RegionSpieler::JuniorU19)
        * Lizenz: []  --  (Group::RegionSpieler::Lizenz)
      * Kontakte
        * Kontakt (TS): []  --  (Group::RegionKontakte::Kontakt)
        * Medien: []  --  (Group::RegionKontakte::Medien)
        * Partner: []  --  (Group::RegionKontakte::Partner)
        * Ehrenmitglied: []  --  (Group::RegionKontakte::Ehrenmitglied)
        * Partner: []  --  (Group::RegionKontakte::Volunteer)
    * Verein
      * Verein
        * J&S Coach (TS): [:group_read]  --  (Group::Verein::JSCoach)
        * Interclub: [:layer_and_below_full]  --  (Group::Verein::Interclub)
        * Event/Turnier (TS): [:group_read]  --  (Group::Verein::EventTurnier)
        * Beauftragte:r Ethik: [:group_read]  --  (Group::Verein::BeauftragterEthik)
        * Umfeldmanager:in: [:group_read]  --  (Group::Verein::Umfeldmanager)
        * Chef:in Ausbildung: [:group_read]  --  (Group::Verein::ChefAusbildung)
        * Chef:in Breitensport: [:group_read]  --  (Group::Verein::ChefBreitensport)
        * Chef:in Leistungssport: [:group_read]  --  (Group::Verein::ChefLeistungssport)
        * Chef:in Nachwuchs: [:group_read]  --  (Group::Verein::ChefNachwuchs)
        * Verantwortliche:r Antidoping: [:group_read]  --  (Group::Verein::VerantwortungAntidoping)
        * Verantwortliche:r Club Management: [:group_read]  --  (Group::Verein::VerantwortungClubmanagement)
        * Verantwortliche:r Finanzen: [:group_read]  --  (Group::Verein::VerantwortungFinanzen)
        * Verantwortliche:r Kommunikation (TS): [:group_read]  --  (Group::Verein::VerantwortungKommunikation)
        * Verantwortliche:r Marketing: [:group_read]  --  (Group::Verein::VerantwortungMarketing)
        * Verantwortliche:r Medical: [:group_read]  --  (Group::Verein::VerantwortungMedical)
        * Verantwortliche:r Personal: [:group_read]  --  (Group::Verein::VerantwortungPersonal)
        * Clubtrainer:in (TS): [:group_read]  --  (Group::Verein::Clubtrainer)
        * Nationalliga: [:group_read]  --  (Group::Verein::Nationalliga)
        * Schiedsrichter:in: [:group_read]  --  (Group::Verein::Schiedsrichter)
      * Vorstand
        * Präsident:in (TS): [:layer_full, :contact_data]  --  (Group::VereinVorstand::Praesident)
        * Vizepräsident:in (TS): [:layer_full, :contact_data]  --  (Group::VereinVorstand::Vizepraesident)
        * Kassier:in (TS): [:layer_read, :contact_data, :finance]  --  (Group::VereinVorstand::Kassier)
        * Vorstandsmitglied: [:layer_full, :contact_data]  --  (Group::VereinVorstand::Mitglied)
        * Sekretär:in: [:layer_and_below_full, :contact_data, :finance]  --  (Group::VereinVorstand::Sekretaer)
      * Spieler
        * Aktivmitglied (TS): [:group_read]  --  (Group::VereinSpieler::Aktivmitglied)
        * Passivmitglied (TS): [:group_read]  --  (Group::VereinSpieler::Passivmitglied)
        * Junior:in (bis U-15) (TS): [:group_read]  --  (Group::VereinSpieler::JuniorU15)
        * Junior:in (U17-U19) (TS): [:group_read]  --  (Group::VereinSpieler::JuniorU19)
        * Lizenz (TS): [:group_read]  --  (Group::VereinSpieler::Lizenz)
        * Vereinigungsspieler:in (TS): [:group_read]  --  (Group::VereinSpieler::Vereinigungsspieler)
        * Lizenz Plus Junior:innen (U19) (TS): [:group_read]  --  (Group::VereinSpieler::LizenzPlusJunior)
        * Lizenz Plus (TS): [:group_read]  --  (Group::VereinSpieler::LizenzPlus)
        * Lizenz NO ranking (TS): [:group_read]  --  (Group::VereinSpieler::LizenzNoRanking)
      * Kontakte
        * Kontakt (TS): []  --  (Group::VereinKontakte::Kontakt)
        * Medien: []  --  (Group::VereinKontakte::Medien)
        * Partner: []  --  (Group::VereinKontakte::Partner)
        * Ehrenmitglied: []  --  (Group::VereinKontakte::Ehrenmitglied)
        * Partner: []  --  (Group::VereinKontakte::Volunteer)
    * Center (Mitglied)
      * Center (Mitglied)
        * Direktion (TS): [:group_full, :contact_data]  --  (Group::Center::Direktion)
    * Center
      * Center
        * Direktion (TS): [:group_full, :contact_data]  --  (Group::CenterUnaffilliated::Direktion)
(Output of rake app:hitobito:roles)
<!-- roles:end -->
