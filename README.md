# Hitobito SWB

This hitobito wagon defines the organization hierarchy with groups and roles
of Swiss Badminton.

## Additional Features

- Imports via CSV files [Import](./doc/import.md)
- Updates certain Person, Groups and Roles to [TournamentSoftware](./doc/tournament_software.md)

## SWB Organization Hierarchy

<!-- roles:start -->
    * Dachverband
      * Dachverband
        * Administrator:in: [:admin, :layer_and_below_full, :impersonation]  --  (Group::Dachverband::Administrator)
      * Vorstand
        * Präsident:in: [:layer_full]  --  (Group::DachverbandVorstand::Praesident)
        * Vizepräsident:in: [:layer_full]  --  (Group::DachverbandVorstand::Vizepraesident)
        * Vorstandsmitglied: [:layer_full]  --  (Group::DachverbandVorstand::Mitglied)
      * Geschäftsstelle
        * Geschäftsführer:in: [:layer_and_below_full, :admin, :approve_applications]  --  (Group::DachverbandGeschaeftsstelle::Geschaeftsfuehrer)
        * Mitglied: [:group_read]  --  (Group::DachverbandGeschaeftsstelle::Mitglied)
        * J+S Coach: [:group_read]  --  (Group::DachverbandGeschaeftsstelle::JSCoach)
        * Verantwortliche:r Antidoping: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Antidoping)
        * Verantwortliche:r Ausbildung: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Ausbildung)
        * Verantwortliche:r Breitensport: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Breitensport)
        * Verantwortliche:r Club Management: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Clubmanagement)
        * Verantwortliche:r Ethik: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Ethik)
        * Verantwortliche:r Event/Turnier: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::EventTurnier)
        * Verantwortliche:r Finanzen: [:layer_and_below_full, :impersonation, :finance]  --  (Group::DachverbandGeschaeftsstelle::Finanzen)
        * Verantwortliche:r Interclub (TS): [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Interclub)
        * Verantwortliche:r Kommunikation: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Kommunikation)
        * Verantwortliche:r Leistungssport: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Leistungssport)
        * Verantwortliche:r Marketing: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Marketing)
        * Verantwortliche:r Medical: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Medical)
        * Verantwortliche:r Nachwuchs: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Nachwuchs)
        * Verantwortliche:r Personal: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Personal)
        * Verantwortliche:r Umfeld: [:layer_and_below_full, :impersonation]  --  (Group::DachverbandGeschaeftsstelle::Umfeld)
      * Kommission
        * Leiter:in: [:group_full]  --  (Group::DachverbandKommission::Leitung)
        * Mitglied: [:group_read]  --  (Group::DachverbandKommission::Mitglied)
      * Kader
        * Trainer:in: [:group_read]  --  (Group::DachverbandKader::Trainer)
        * Athlet:in: [:group_read]  --  (Group::DachverbandKader::Athlet)
      * Spieler:innen
        * Aktivmitglied (TS): []  --  (Group::DachverbandSpieler::Aktivmitglied)
        * Passivmitglied (TS): []  --  (Group::DachverbandSpieler::Passivmitglied)
        * Lizenz Nachwuchs bis U15 (TS): []  --  (Group::DachverbandSpieler::JuniorU15)
        * Lizenz Nachwuchs U17-U19 (TS): []  --  (Group::DachverbandSpieler::JuniorU19)
        * Aktivmitgliedschaft bis U15 (TS): []  --  (Group::DachverbandSpieler::AktivmitgliedU15)
        * Aktivmitgliedschaft U17-U19 (TS): []  --  (Group::DachverbandSpieler::AktivmitgliedU19)
        * Lizenz: []  --  (Group::DachverbandSpieler::Lizenz)
      * Technisch / Offiziell
        * Linienrichter:in: [:group_read]  --  (Group::DachverbandTechnischoffiziell::Linienrichter)
        * Referee: [:group_read]  --  (Group::DachverbandTechnischoffiziell::Referee)
        * Schiedsrichter:in: [:group_read]  --  (Group::DachverbandTechnischoffiziell::Schiedsrichter)
      * Kontakte
        * Kontakt: []  --  (Group::DachverbandKontakte::Kontakt)
        * Ehemaliges ZV-Mitglied: []  --  (Group::DachverbandKontakte::EhemaligesZvmitglied)
        * Ehemalige:r Mitarbeiter:in: []  --  (Group::DachverbandKontakte::EhemaligerMitarbeiter)
        * Ehrenmitglied: []  --  (Group::DachverbandKontakte::Ehrenmitglied)
        * Shuttletime-Tutor: []  --  (Group::DachverbandKontakte::ShuttletimeTutor)
        * Gönner:in: []  --  (Group::DachverbandKontakte::Goenner)
        * Medien: []  --  (Group::DachverbandKontakte::Medien)
        * Partner: []  --  (Group::DachverbandKontakte::Partner)
        * J+S Expert:in: []  --  (Group::DachverbandKontakte::JSExperte)
    * Region < Dachverband
      * Region
        * J+S Coach: [:group_read]  --  (Group::Region::JSCoach)
        * Verantwortliche:r Antidoping: [:group_read]  --  (Group::Region::Antidoping)
        * Verantwortliche:r Ausbildung: [:group_read]  --  (Group::Region::Ausbildung)
        * Verantwortliche:r Breitensport: [:group_read]  --  (Group::Region::Breitensport)
        * Verantwortliche:r Club Management: [:group_read]  --  (Group::Region::Clubmanagement)
        * Verantwortliche:r Ethik: [:group_read]  --  (Group::Region::Ethik)
        * Verantwortliche:r Event/Turnier: [:group_read]  --  (Group::Region::EventTurnier)
        * Verantwortliche:r Interclub (TS): [:layer_and_below_full]  --  (Group::Region::Interclub)
        * Verantwortliche:r Kommunikation: [:group_read]  --  (Group::Region::Kommunikation)
        * Verantwortliche:r Leistungssport: [:group_read]  --  (Group::Region::Leistungssport)
        * Verantwortliche:r Marketing: [:group_read]  --  (Group::Region::Marketing)
        * Verantwortliche:r Medical: [:group_read]  --  (Group::Region::Medical)
        * Verantwortliche:r Nachwuchs: [:group_read]  --  (Group::Region::Nachwuchs)
        * Verantwortliche:r Personal: [:group_read]  --  (Group::Region::Personal)
        * Verantwortliche:r Umfeld: [:group_read]  --  (Group::Region::Umfeld)
      * Vorstand
        * Präsident:in: [:layer_and_below_full]  --  (Group::RegionVorstand::Praesident)
        * Vizepräsident:in: [:layer_and_below_full]  --  (Group::RegionVorstand::Vizepraesident)
        * Administrator:in: [:layer_and_below_full, :finance]  --  (Group::RegionVorstand::Administrator)
        * Verantwortliche:r Finanzen: [:layer_and_below_full, :finance]  --  (Group::RegionVorstand::Finanzen)
        * Vorstandsmitglied: [:layer_and_below_full]  --  (Group::RegionVorstand::Mitglied)
      * Spieler:innen
        * Aktivmitglied (TS): []  --  (Group::RegionSpieler::Aktivmitglied)
        * Passivmitglied (TS): []  --  (Group::RegionSpieler::Passivmitglied)
        * Lizenz Nachwuchs bis U15 (TS): []  --  (Group::RegionSpieler::JuniorU15)
        * Lizenz Nachwuchs U17-U19 (TS): []  --  (Group::RegionSpieler::JuniorU19)
        * Aktivmitgliedschaft bis U15 (TS): []  --  (Group::RegionSpieler::AktivmitgliedU15)
        * Aktivmitgliedschaft U17-U19 (TS): []  --  (Group::RegionSpieler::AktivmitgliedU19)
        * Lizenz: []  --  (Group::RegionSpieler::Lizenz)
      * Kontakte
        * Kontakt: []  --  (Group::RegionKontakte::Kontakt)
        * Medien: []  --  (Group::RegionKontakte::Medien)
        * Partner: []  --  (Group::RegionKontakte::Partner)
        * Ehrenmitglied: []  --  (Group::RegionKontakte::Ehrenmitglied)
        * Partner: []  --  (Group::RegionKontakte::Volunteer)
    * Verein < Region
      * Verein
        * J+S Coach: [:group_read]  --  (Group::Verein::JSCoach)
        * Schiedsrichter:in: [:group_read]  --  (Group::Verein::Schiedsrichter)
        * Clubtrainer:in (TS): [:group_read]  --  (Group::Verein::Clubtrainer)
        * Nationalliga: [:group_read]  --  (Group::Verein::Nationalliga)
        * Verantwortliche:r Antidoping: [:group_read]  --  (Group::Verein::Antidoping)
        * Verantwortliche:r Ausbildung: [:group_read]  --  (Group::Verein::Ausbildung)
        * Verantwortliche:r Ethik: [:group_read]  --  (Group::Verein::Ethik)
        * Verantwortliche:r Breitensport: [:group_read]  --  (Group::Verein::Breitensport)
        * Verantwortliche:r Club Management: [:group_read]  --  (Group::Verein::Clubmanagement)
        * Verantwortliche:r Event/Turnier (TS): [:group_read]  --  (Group::Verein::EventTurnier)
        * Verantwortliche:r Interclub (TS): [:layer_full]  --  (Group::Verein::Interclub)
        * Verantwortliche:r Kommunikation: [:group_read]  --  (Group::Verein::Kommunikation)
        * Verantwortliche:r Leistungssport: [:group_read]  --  (Group::Verein::Leistungssport)
        * Verantwortliche:r Marketing: [:group_read]  --  (Group::Verein::Marketing)
        * Verantwortliche:r Medical: [:group_read]  --  (Group::Verein::Medical)
        * Verantwortliche:r Nachwuchs: [:group_read]  --  (Group::Verein::Nachwuchs)
        * Verantwortliche:r Personal: [:group_read]  --  (Group::Verein::Personal)
        * Verantwortliche:r Umfeld: [:group_read]  --  (Group::Verein::Umfeld)
      * Vorstand
        * Präsident:in: [:layer_full, :players_group_read]  --  (Group::VereinVorstand::Praesident)
        * Vizepräsident:in: [:layer_full, :players_group_read]  --  (Group::VereinVorstand::Vizepraesident)
        * Verantwortliche:r Finanzen: [:layer_full, :finance]  --  (Group::VereinVorstand::Finanzen)
        * Vorstandsmitglied: [:layer_full, :players_group_read]  --  (Group::VereinVorstand::Mitglied)
        * Administrator:in: [:layer_full, :finance]  --  (Group::VereinVorstand::Administrator)
      * Spieler:innen
        * Aktivmitglied (TS): []  --  (Group::VereinSpieler::Aktivmitglied)
        * Passivmitglied (TS): []  --  (Group::VereinSpieler::Passivmitglied)
        * Lizenz Nachwuchs bis U15 (TS): []  --  (Group::VereinSpieler::JuniorU15)
        * Lizenz Nachwuchs U17-U19 (TS): []  --  (Group::VereinSpieler::JuniorU19)
        * Aktivmitgliedschaft bis U15 (TS): []  --  (Group::VereinSpieler::AktivmitgliedU15)
        * Aktivmitgliedschaft U17-U19 (TS): []  --  (Group::VereinSpieler::AktivmitgliedU19)
        * Lizenz (TS): []  --  (Group::VereinSpieler::Lizenz)
        * Lizenz Plus Nachwuchs (U19) (TS): []  --  (Group::VereinSpieler::LizenzPlusJunior)
        * Lizenz Plus (TS): []  --  (Group::VereinSpieler::LizenzPlus)
        * Lizenz NO ranking (TS): []  --  (Group::VereinSpieler::LizenzNoRanking)
        * Vereinigungsspieler:in (TS): []  --  (Group::VereinSpieler::Vereinigungsspieler)
      * Kontakte
        * Kontakt: []  --  (Group::VereinKontakte::Kontakt)
        * Medien: []  --  (Group::VereinKontakte::Medien)
        * Partner: []  --  (Group::VereinKontakte::Partner)
        * Ehrenmitglied: []  --  (Group::VereinKontakte::Ehrenmitglied)
        * Partner: []  --  (Group::VereinKontakte::Volunteer)
    * Center (Mitglied) < Dachverband
      * Center (Mitglied)
        * Direktion: [:group_full]  --  (Group::Center::Direktion)
    * Center < Dachverband
      * Center
        * Direktion: [:group_full]  --  (Group::CenterUnaffilliated::Direktion)
(Output of rake app:hitobito:roles)
<!-- roles:end -->
