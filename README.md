# Hitobito SWB

This hitobito wagon defines the organization hierarchy with groups and roles
of Swiss Badminton.

Additional Features are: to be defined ;-)

## SWB Organization Hierarchy

<!-- roles:start -->
    * Dachverband
      * Dachverband
        * Administrator:in: [:admin, :layer_and_below_full, :impersonation]
      * Vorstand
        * Präsident:in: [:layer_full, :contact_data]
        * Vizepräsident:in: [:layer_full, :contact_data]
        * Vorstandsmitglied: [:layer_full, :contact_data]
      * Geschäftsstelle
        * Geschäftsführer:in: [:layer_and_below_full, :admin, :contact_data, :approve_applications, :finance]
        * Kassier:in: [:layer_and_below_full, :contact_data, :finance]
        * Mitglied: [:layer_and_below_full, :contact_data, :approve_applications]
      * Gremium/Projektgruppe
        * Leiter:in: [:group_and_below_full, :contact_data]
        * Mitglied: [:group_and_below_read]
      * Mitglieder
        * Aktivmitglied: []
        * Passivmitglied: []
        * Junior:in (bis U-15): []
        * Junior:in (U17-U19): []
        * Lizenz: []
        * Vereinigungsspieler:in: []
        * Lizenz Plus Junior:in (U19): []
        * Lizenz Plus: []
        * Shuttletime: []
        * Lizenz NO ranking: []
        * J&S Coach: [:group_read]
      * Kontakte
        * Kontakt: []
    * Region < Dachverband
      * Region
        * Administrator:in: [:layer_and_below_full, :contact_data, :finance]
      * Vorstand
        * Präsident:in: [:layer_full, :contact_data]
        * Vizepräsident:in: [:layer_full, :contact_data]
        * Kassier:in: [:layer_read, :contact_data, :finance]
        * Vorstandsmitglied: [:layer_full, :contact_data]
      * Mitglieder
        * Aktivmitglied: []
        * Passivmitglied: []
        * Junior:in (bis U-15): []
        * Junior:in (U17-U19): []
        * Lizenz: []
        * Vereinigungsspieler:in: []
        * Lizenz Plus Junior:innen (U19): []
        * Lizenz Plus: []
        * Shuttletime: []
        * Lizenz NO ranking: []
        * J&S Coach: [:group_read]
      * Kontakte
        * Adressverwalter:in: [:group_and_below_full]
        * Kontakt: []
    * Verein < Region
      * Verein
        * Hauptleiter:in: [:layer_and_below_full]
        * Adressverwalter:in: [:group_and_below_full]
        * Leiter:in: [:group_and_below_full, :contact_data]
        * Aktivmitglied: [:group_and_below_read]
      * Vorstand
        * Präsident:in: [:layer_full, :contact_data]
        * Vizepräsident:in: [:layer_full, :contact_data]
        * Kassier:in: [:layer_read, :contact_data, :finance]
        * Vorstandsmitglied: [:layer_full, :contact_data]
      * Mitglieder
        * Aktivmitglied: []
        * Passivmitglied: []
        * Junior:in (bis U-15): []
        * Junior:in (U17-U19): []
        * Lizenz: []
        * Clubtrainer:in: []
        * Ehrenmitglied: []
        * J&S Expert:in: []
        * Kaderspieler:in: []
        * Turnierorganisator:in: []
        * Volunteer: []
        * ZV-Mitglied: []
        * Vereinigungsspieler:in: []
        * Lizenz Plus Junior:innen (U19): []
        * Lizenz Plus: []
        * Shuttletime: []
        * Lizenz NO ranking: []
        * J&S Coach: [:group_read]
      * Kontakte
        * Adressverwalter:in: [:group_and_below_full]
        * Kontakt: []
    * Center < Dachverband
      * Center
        * Center: []
        * Kontakt: []

(Output of rake app:hitobito:roles)
<!-- roles:end -->