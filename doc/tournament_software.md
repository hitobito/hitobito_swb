# Tournament software

Ursprünglich verwaltete Swiss Badminton (SB) ihre Daten nur in TournamentSoftware (TS). Aktuell wird
TS nur noch für den Spielbetrieb (Liga, Tournier, Ranglisten usw) verwendet, die Stammdatenverwaltung
(Gruppen, Personen, Rollen) passiert in hitobito (HB).

Damit TS weiterhin relevante und aktuelle Daten erhält, synchronisiert HB gewisse Daten zurück nach TS.
Die Synchronisierung passiert via Jobs, die von Controller actions gescheduled werden und die Daten nach 
TS schreiben. Es **wird nicht** von TS gelesen.




## Interaktion mit dem API

Dokumentation unter https://api-se.tournamentsoftware.com/Documentation verfügbar. Datenaustausch Format ist XML
`Content-Type: text/xml`. Schnittstelle respektiert HTTP Prinzipien, ist aber nicht streng restful.

    curl -s -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization |  xmllint --format -

    curl -s -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization/$TS_ORGANIZATION/RootGroup |  xmllint --format -

    curl -s -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization/$TS_ORGANIZATION/Person/$TS_PERSON/Membership |  xmllint --format -


Anlegen von Resource erfolgt über POST auf dem Collection Endpoint, e.g

    echo -e '
       <OrganizationGroup>
            <ParentCode>65878A6B-0F41-4494-B9A1-1DEEA68153C6</ParentCode>
            <Name>SB API Test</Name>
            <DisplayName>Testing API Endpoint</DisplayName>
        </OrganizationGroup>
    ' | curl -X POST -d @- -H 'Content-Type: text/xml'  -s -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization/$TS_ORGANIZATION/Group | xmllint --format -

und liefert ein entsprechendes Result mit `Error` (code 0 falls erfolgreich) und der Entity mit `Code` (Identifier)

    <?xml version="1.0" encoding="utf-8"?>
    <Result Version="1.0">
      <Error>
        <Code>0</Code>
        <Message>Success</Message>
      </Error>
      <OrganizationGroup>
        <Code>2A2623C8-AD4A-41D6-94CE-68F594E7C503</Code>
        <Name>SB API Test</Name>
      </OrganizationGroup>
    </Result>

Aktualisieren von einer Resource erfolgt über PUT auf dem Resource Endpoint (ausser bei Nested Resourcen zb. Rollen)

    echo -e '
       <OrganizationGroup>
            <Code>2A2623C8-AD4A-41D6-94CE-68F594E7C503</Code>
            <ParentCode>65878A6B-0F41-4494-B9A1-1DEEA68153C6</ParentCode>
            <Name>SB API Test</Name>
            <DisplayName>Testing API Endpoint</DisplayName>
        </OrganizationGroup>
    ' | curl -X PUT -d @- -H 'Content-Type: text/xml' -s -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization/$TS_ORGANIZATION/Group/2A2623C8-AD4A-41D6-94CE-68F594E7C503 | xmllint --format -


    <?xml version="1.0" encoding="utf-8"?>
    <Result Version="1.0">
      <Error>
        <Code>0</Code>
        <Message>Success</Message>
      </Error>
      <OrganizationGroup>
        <Code>B4CBFC14-4505-4245-8A73-7F1F3043CBA3</Code>
        <Name>SB API Test - Update</Name>
      </OrganizationGroup>
    </Result>


## Rollen (nested unter members)

Für Rollen wird immer mit der Nesting Resorcen (Member) interagiert, die Rolle wird via Code nur im Payload und nicht in
der URL identifiziert.

## Aktueller Stand

- [x] Anlegen von Person
- [x] Updaten von Person
- [ ] Löschen von Person (API unklar)

- [x] Anlegen von Gruppe
- [x] Updaten von Gruppe
- [ ] Löschen von Gruppe (API unklar)

- [x] Anlegen von Rolle
- [x] Updaten von Rolle
- [ ] Löschen von Rolle (API unklar, kein code bei importierten Rollen)
