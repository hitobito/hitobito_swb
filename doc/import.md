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
Kontakte, usw) die in TS nicht existieren.


Ist das so gewollt? Wie gehen mir damit um, dass nur manche Gruppen in TS sind.
Was bedeutet das fürs API?  (zb Spieler Gruppe ist nicht in TS nur Verein)

Weiter Punkte

- [ ] Nach dem import sind 102 Gruppen leer, sollen wir alle löschen damit sie besser sehen was da ist? 
    $> Group.where.not('layer_group_id = groups.id').left_joins(:roles).where(roles: { id: nil }).destroy_all (soft delete)

- [ ] Neue Rollen in hitobito festlegen anhand von TS Rollen (liste mit ihnen fixieren)




## CSV STATS

 csvstat tmp/mitglieder.csv
/usr/lib/python3/dist-packages/agate/table/from_csv.py:67: RuntimeWarning: Error sniffing CSV dialect: Could not determine delimiter
  kwargs['dialect'] = csv.Sniffer().sniff(contents.getvalue()[:sniff_limit])
  1. "groupcode"

        Type of data:          Text
        Contains null values:  False
        Non-null values:       17892
        Unique values:         314
        Longest value:         36 characters
        Most common values:    E7488547-57A8-4552-8DEB-EFD826791509 (300x)
                               43B95553-87B2-48EB-A04D-FAF0E5AF6C76 (242x)
                               D7D7C5CE-BD9E-4D77-8560-11ED4492D48C (229x)
                               5D4B6848-3A59-4B0E-8AF7-914D126A3F51 (217x)
                               2970CCBE-F256-448F-AD26-83A9C71DF56E (217x)

  2. "groupnumber"

        Type of data:          Text
        Contains null values:  False
        Non-null values:       17892
        Unique values:         314
        Longest value:         5 characters
        Most common values:    208 (300x)
                               32 (242x)
                               64 (229x)
                               136 (217x)
                               243 (217x)

  3. "groupname"

        Type of data:          Text
        Contains null values:  False
        Non-null values:       17892
        Unique values:         313
        Longest value:         52 characters
        Most common values:    BC Rousseau (300x)
                               BC Genève (242x)
                               Badminton Lausanne Association (229x)
                               BC Uni Bern (217x)
                               BC Olympica-Brig (217x)

  4. "code"

        Type of data:          Text
        Contains null values:  False
        Non-null values:       17892
        Unique values:         14597
        Longest value:         36 characters
        Most common values:    AE6886AF-1A22-4ADB-8F78-C88DB6F52BCA (18x)
                               2A2EAF48-D8AC-4936-8419-C17939488278 (15x)
                               872FBF02-1A85-461D-B17F-EA15A6705A7F (13x)
                               707EC099-7FAD-4D51-8A88-316DFB5E1D0D (12x)
                               8846FE94-5B64-4305-AFD2-EDF4A2A767A8 (11x)

  5. "memberid"

        Type of data:          Number
        Contains null values:  False
        Non-null values:       17892
        Unique values:         14597
        Smallest value:        10033
        Largest value:         411129
        Sum:                   4146819518
        Mean:                  231769.479
        Median:                203662.5
        StDev:                 154161.351
        Most decimal places:   0
        Most common values:    83375 (18x)
                               30429 (15x)
                               68780 (13x)
                               109125 (12x)
                               406380 (11x)

  6. "International Member ID"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       428
        Unique values:         267
        Longest value:         7 characters
        Most common values:    None (17464x)
                               87661 (9x)
                               75702 (7x)
                               89499 (7x)
                               78084 (7x)

  7. "National ID"

        Type of data:          Boolean
        Contains null values:  True (excluded from calculations)
        Non-null values:       0
        Unique values:         1
        Most common values:    None (17892x)

  8. "lastname"

        Type of data:          Text
        Contains null values:  False
        Non-null values:       17892
        Unique values:         8288
        Longest value:         29 characters
        Most common values:    Müller (139x)
                               Schmid (77x)
                               Keller (76x)
                               Meier (74x)
                               Schneider (48x)

  9. "lastname2"

        Type of data:          Boolean
        Contains null values:  True (excluded from calculations)
        Non-null values:       0
        Unique values:         1
        Most common values:    None (17892x)

 10. "middlename"

        Type of data:          Boolean
        Contains null values:  True (excluded from calculations)
        Non-null values:       0
        Unique values:         1
        Most common values:    None (17892x)

 11. "firstname"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       17878
        Unique values:         4157
        Longest value:         30 characters
        Most common values:    Thomas (173x)
                               Daniel (166x)
                               Christian (165x)
                               Martin (133x)
                               Michael (123x)

 12. "address"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       17818
        Unique values:         12570
        Longest value:         89 characters
        Most common values:    None (74x)
                               c/o Rolex SA (69x)
                               François Dussaud 3-5-7 (54x)
                               Case postale (27x)
                               Rolex SA, case postale (23x)

 13. "address2"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       145
        Unique values:         75
        Longest value:         44 characters
        Most common values:    None (17747x)
                               c/o Rolex SA (33x)
                               Chemin (9x)
                               chez Philippe Dumartheray (5x)
                               150 (4x)

 14. "address3"

        Type of data:          Boolean
        Contains null values:  True (excluded from calculations)
        Non-null values:       0
        Unique values:         1
        Most common values:    None (17892x)

 15. "postalcode"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       17824
        Unique values:         1934
        Longest value:         16 characters
        Most common values:    1211 (202x)
                               1920 (108x)
                               9000 (97x)
                               1205 (95x)
                               2000 (94x)

 16. "city"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       17832
        Unique values:         2441
        Longest value:         25 characters
        Most common values:    Zürich (602x)
                               Genève (446x)
                               Bern (372x)
                               Basel (272x)
                               Lausanne (248x)

 17. "state"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       2167
        Unique values:         118
        Longest value:         50 characters
        Most common values:    None (15725x)
                               Vaud (413x)
                               Fribourg (167x)
                               Valais (162x)
                               Genève (152x)

 18. "country"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       17813
        Unique values:         29
        Longest value:         3 characters
        Most common values:    SUI (17497x)
                               FRA (172x)
                               None (79x)
                               GER (34x)
                               LIE (32x)

 19. "nationality"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       17877
        Unique values:         80
        Longest value:         3 characters
        Most common values:    SUI (16006x)
                               FRA (420x)
                               GER (358x)
                               IND (202x)
                               CHN (91x)

 20. "gender"

        Type of data:          Text
        Contains null values:  False
        Non-null values:       17892
        Unique values:         2
        Longest value:         1 characters
        Most common values:    M (11768x)
                               F (6124x)

 21. "dob"

        Type of data:          Date
        Contains null values:  True (excluded from calculations)
        Non-null values:       17836
        Unique values:         10204
        Smallest value:        1928-07-13
        Largest value:         2024-05-30
        Most common values:    None (56x)
                               1969-07-15 (18x)
                               1955-06-08 (15x)
                               1968-01-20 (14x)
                               1968-07-21 (14x)

 22. "phone"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       15372
        Unique values:         11432
        Longest value:         20 characters
        Most common values:    None (2520x)
                               0223022200 (125x)
                               0786061108 (35x)
                               000 000 00 00 (21x)
                               022 788 90 08 (19x)

 23. "phone2"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       2612
        Unique values:         1869
        Longest value:         21 characters
        Most common values:    None (15280x)
                               071 344 14 49 (15x)
                               022 757 05 70 (11x)
                               056 427 45 45 (11x)
                               079 725 62 91 (10x)

 24. "mobile"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       4491
        Unique values:         3073
        Longest value:         20 characters
        Most common values:    None (13401x)
                               079 572 38 65 (18x)
                               079 295 58 23 (15x)
                               079 789 90 08 (13x)
                               079 635 84 38 (11x)

 25. "fax"

        Type of data:          Boolean
        Contains null values:  True (excluded from calculations)
        Non-null values:       0
        Unique values:         1
        Most common values:    None (17892x)

 26. "fax2"

        Type of data:          Boolean
        Contains null values:  True (excluded from calculations)
        Non-null values:       0
        Unique values:         1
        Most common values:    None (17892x)

 27. "email"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       17408
        Unique values:         13059
        Longest value:         43 characters
        Most common values:    None (484x)
                               nom.prenom@mail.com (129x)
                               balz006@hotmail.com (30x)
                               x@y.com (20x)
                               alex.hueber@gmx.net (18x)

 28. "website"

        Type of data:          Boolean
        Contains null values:  True (excluded from calculations)
        Non-null values:       0
        Unique values:         1
        Most common values:    None (17892x)

 29. "categoryname"

        Type of data:          Boolean
        Contains null values:  True (excluded from calculations)
        Non-null values:       0
        Unique values:         1
        Most common values:    None (17892x)

 30. "startdate"

        Type of data:          Date
        Contains null values:  False
        Non-null values:       17892
        Unique values:         1903
        Smallest value:        2016-01-01
        Largest value:         2025-02-21
        Most common values:    2016-01-06 (1562x)
                               2025-01-01 (919x)
                               2016-01-05 (580x)
                               2024-01-01 (550x)
                               2016-01-01 (453x)

 31. "endate"

        Type of data:          DateTime
        Contains null values:  False
        Non-null values:       17892
        Unique values:         5
        Smallest value:        2025-06-14 23:59:59
        Largest value:         9999-12-31 23:59:59.997000
        Most common values:    9999-12-31 23:59:59 (17728x)
                               9999-12-31 23:59:59.997000 (104x)
                               9999-12-31 00:00:00 (45x)
                               2025-06-14 23:59:59 (14x)
                               2025-06-30 00:00:00 (1x)

 32. "role"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       17889
        Unique values:         44
        Longest value:         30 characters
        Most common values:    Spieler (15051x)
                               Club Interclub (542x)
                               Club Präsident (303x)
                               Club Kontaktadresse (272x)
                               Club Finanzen (269x)

 33. "TypeName"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       15061
        Unique values:         10
        Longest value:         24 characters
        Most common values:    Lizenz (4422x)
                               Passiv (4220x)
                               None (2831x)
                               Junior (up to U15) (2347x)
                               Junior (U17-U19) (1972x)

 34. "bankaccountnumber"

        Type of data:          Boolean
        Contains null values:  True (excluded from calculations)
        Non-null values:       0
        Unique values:         1
        Most common values:    None (17892x)

 35. "bankaccountholder"

        Type of data:          Boolean
        Contains null values:  True (excluded from calculations)
        Non-null values:       0
        Unique values:         1
        Most common values:    None (17892x)

 36. "remarks"

        Type of data:          Text
        Contains null values:  True (excluded from calculations)
        Non-null values:       7366
        Unique values:         33
        Longest value:         100 characters
        Most common values:    None (10526x)
                               A (2676x)
                               S45 (864x)
                               S40 (781x)
                               S35 (699x)

 37. "PlayerLevelSingle"

        Type of data:          Text
        Contains null values:  False
        Non-null values:       17892
        Unique values:         6
        Longest value:         3 characters
        Most common values:    D (8047x)
                               NL (6743x)
                               C (2104x)
                               B (720x)
                               A (230x)

 38. "PlayerLevelDouble"

        Type of data:          Text
        Contains null values:  False
        Non-null values:       17892
        Unique values:         6
        Longest value:         3 characters
        Most common values:    D (8012x)
                               NL (6743x)
                               C (2120x)
                               B (717x)
                               A (253x)

 39. "PlayerLevelMixed"

        Type of data:          Text
        Contains null values:  False
        Non-null values:       17892
        Unique values:         6
        Longest value:         3 characters
        Most common values:    D (7972x)
                               NL (6743x)
                               C (2158x)
                               B (723x)
                               A (236x)

 40. "Language"

        Type of data:          Text
        Contains null values:  False
        Non-null values:       17892
        Unique values:         5
        Longest value:         51 characters
        Most common values:    Deutsch (SUI) (10449x)
                               Französisch (SUI) (6757x)
                               Englisch (GBR) (559x)
                               [Resource key not found (Organization.Language:0).] (88x)
                               Italienisch (SUI) (39x)

 41. "Dienstleistungs-Angebote"

        Type of data:          Boolean
        Contains null values:  False
        Non-null values:       17892
        Unique values:         2
        Most common values:    True (12258x)
                               False (5634x)

 42. "Mitteilungen"

        Type of data:          Boolean
        Contains null values:  False
        Non-null values:       17892
        Unique values:         2
        Most common values:    True (13369x)
                               False (4523x)

Row count: 17892
