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
        * Administrator:in: [:admin, :layer_and_below_full, :impersonation]
      * Vorstand
        * Präsident:in: [:layer_full]
        * Vizepräsident:in: [:layer_full]
        * Vorstandsmitglied: [:layer_full]
      * Geschäftsstelle
        * Geschäftsführer:in: [:layer_and_below_full, :admin, :approve_applications]
        * Mitglied: [:group_read]
        * J+S Coach: [:group_read]
        * Verantwortliche:r Antidoping: [:layer_and_below_full, :impersonation]
        * Verantwortliche:r Ausbildung: [:layer_and_below_full, :impersonation]
        * Verantwortliche:r Breitensport: [:layer_and_below_full, :impersonation]
        * Verantwortliche:r Club Management: [:layer_and_below_full, :impersonation]
        * Verantwortliche:r Ethik: [:layer_and_below_full, :impersonation]
        * Verantwortliche:r Event/Turnier: [:layer_and_below_full, :impersonation]
        * Verantwortliche:r Finanzen: [:layer_and_below_full, :impersonation, :finance]
        * Verantwortliche:r Interclub (TS): [:layer_and_below_full, :impersonation]
        * Verantwortliche:r Kommunikation: [:layer_and_below_full, :impersonation]
        * Verantwortliche:r Leistungssport: [:layer_and_below_full, :impersonation]
        * Verantwortliche:r Marketing: [:layer_and_below_full, :impersonation]
        * Verantwortliche:r Medical: [:layer_and_below_full, :impersonation]
        * Verantwortliche:r Nachwuchs: [:layer_and_below_full, :impersonation]
        * Verantwortliche:r Personal: [:layer_and_below_full, :impersonation]
        * Verantwortliche:r Umfeld: [:layer_and_below_full, :impersonation]
      * Kommission
        * Leiter:in: [:group_full]
        * Mitglied: [:group_read]
      * Kader
        * Trainer:in: [:group_read]
        * Athlet:in: [:group_read]
      * Spieler:innen
        * Aktivmitglied (TS): []
        * Passivmitglied (TS): []
        * Junior:in (bis U15) (TS): []
        * Junior:in (U17-U19) (TS): []
        * Lizenz: []
      * Technisch / Offiziell
        * Linienrichter:in: [:group_read]
        * Referee: [:group_read]
        * Schiedsrichter:in: [:group_read]
      * Kontakte
        * Kontakt: []
        * Ehemaliges ZV-Mitglied: []
        * Ehemalige:r Mitarbeiter:in: []
        * Ehrenmitglied: []
        * Shuttletime-Tutor: []
        * Gönner:in: []
        * Medien: []
        * Partner: []
        * J+S Expert:in: []
    * Region < Dachverband
      * Region
        * J+S Coach: [:group_read]
        * Verantwortliche:r Antidoping: [:group_read]
        * Verantwortliche:r Ausbildung: [:group_read]
        * Verantwortliche:r Breitensport: [:group_read]
        * Verantwortliche:r Club Management: [:group_read]
        * Verantwortliche:r Ethik: [:group_read]
        * Verantwortliche:r Event/Turnier: [:group_read]
        * Verantwortliche:r Interclub (TS): [:layer_and_below_full]
        * Verantwortliche:r Kommunikation: [:group_read]
        * Verantwortliche:r Leistungssport: [:group_read]
        * Verantwortliche:r Marketing: [:group_read]
        * Verantwortliche:r Medical: [:group_read]
        * Verantwortliche:r Nachwuchs: [:group_read]
        * Verantwortliche:r Personal: [:group_read]
        * Verantwortliche:r Umfeld: [:group_read]
      * Vorstand
        * Präsident:in: [:layer_and_below_read]
        * Vizepräsident:in: [:layer_and_below_read]
        * Administrator:in: [:layer_and_below_full, :finance]
        * Verantwortliche:r Finanzen: [:layer_and_below_read, :finance]
        * Vorstandsmitglied: [:layer_and_below_read]
      * Spieler:innen
        * Aktivmitglied (TS): []
        * Passivmitglied (TS): []
        * Junior:in (bis U15) (TS): []
        * Junior:in (U17-U19) (TS): []
        * Lizenz: []
      * Kontakte
        * Kontakt: []
        * Medien: []
        * Partner: []
        * Ehrenmitglied: []
        * Partner: []
    * Verein < Region
      * Verein
        * J+S Coach: [:group_read]
        * Schiedsrichter:in: [:group_read]
        * Clubtrainer:in (TS): [:group_read]
        * Nationalliga: [:group_read]
        * Verantwortliche:r Antidoping: [:group_read]
        * Verantwortliche:r Ausbildung: [:group_read]
        * Verantwortliche:r Ethik: [:group_read]
        * Verantwortliche:r Breitensport: [:group_read]
        * Verantwortliche:r Club Management: [:group_read]
        * Verantwortliche:r Event/Turnier (TS): [:group_read]
        * Verantwortliche:r Interclub (TS): [:layer_full]
        * Verantwortliche:r Kommunikation: [:group_read]
        * Verantwortliche:r Leistungssport: [:group_read]
        * Verantwortliche:r Marketing: [:group_read]
        * Verantwortliche:r Medical: [:group_read]
        * Verantwortliche:r Nachwuchs: [:group_read]
        * Verantwortliche:r Personal: [:group_read]
        * Verantwortliche:r Umfeld: [:group_read]
      * Vorstand
        * Präsident:in: [:group_read, :players_group_read]
        * Vizepräsident:in: [:group_read, :players_group_read]
        * Verantwortliche:r Finanzen: [:layer_read, :finance]
        * Vorstandsmitglied: [:group_read, :players_group_read]
        * Administrator:in: [:layer_full, :finance]
      * Spieler:innen
        * Aktivmitglied (TS): []
        * Passivmitglied (TS): []
        * Junior:in (bis U15) (TS): []
        * Junior:in (U17-U19) (TS): []
        * Lizenz (TS): []
        * Lizenz Plus Junior:innen (U19) (TS): []
        * Lizenz Plus (TS): []
        * Lizenz NO ranking (TS): []
        * Vereinigungsspieler:in (TS): []
      * Kontakte
        * Kontakt: []
        * Medien: []
        * Partner: []
        * Ehrenmitglied: []
        * Partner: []
    * Center (Mitglied) < Dachverband
      * Center (Mitglied)
        * Direktion: [:group_full]
    * Center < Dachverband
      * Center
        * Direktion: [:group_full]
(Output of rake app:hitobito:roles)
<!-- roles:end -->
