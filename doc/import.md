# Import

SWB liefert XLSX files, die via rake file tasks nach CSV konvertiert und
anschliessend einzeln importiert wurden.


Vorausgesetzt folgenden Eingangsdaten sind  im wagon vorhanden:

    ❯ tree data/
    data/
    ├── Mtglieder_Export_Hitobito.xlsx
    └── Structure_SB.xlsx


Dann kann die app im core vorbereite werden:

    $> rake db:drop db:create db:migrate wagon:migrate db:seed


Und anschliessend im wagon importiert werden:

    $> rake swb:import


Dabei werden Personen, Gruppen und Rollen angelegt, siehe auch:

    ❯ tree log/03-11-13_38_39/
    log/03-11-13_38_39/
    ├── 1-people-failed.log
    ├── 1-people-invalid.log
    ├── 1-people-saved.log
    ├── 2-regions-failed.log
    ├── 2-regions-invalid.log
    ├── 2-regions-saved.log
    ├── 3-clubs-failed.log
    ├── 3-clubs-invalid.log
    ├── 3-clubs-saved.log
    ├── 4-roles-failed.log
    ├── 4-roles-invalid.log
    ├── 4-roles-saved.log
    └── info.log


Siehe dazu `lib/task.swb.rake` und `app/domain/swb_import`



## Anpassungen

Struktur in hitobito entspricht nicht der Struktur in Tournamement Software.
Dort hängt die Rolle direkt Verein, wir haben unter Gruppen (Mitglieder,
Kontakte, usw). Ist das so gewollt? Macht uns das noch wo Probleme? Api?
Berechtigungen?
