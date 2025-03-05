# Tournament software

## Was geht
- [x] Anlegen von Person
- [x] Updaten von Person
- [ ] Löschen von Person (API unklar)

- [x] Anlegen von Gruppe
- [x] Updaten von Gruppe
- [ ] Löschen von Gruppe (API unklar)

- [x] Anlegen von Rolle
- [x] Updaten von Rolle
- [ ] Löschen von Rolle (API unklar, kein code bei importierten Rollen)


## Callbacks auf models

- [x] update when ts_code vorhanden ist
- [] anlegen ist schwieriger (wann soll die gruppe angelegt werde?, wann die person?)



## XLT

fürs Transformieren von memberships, brauchen wir hoffentlich nicht

    STYLESHEET = <<~XLST
      <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:output method="xml" indent="yes"/>
        <xsl:template match="@* | node()">
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
        </xsl:template>
        <xsl:template match="OrganizationMemberships">
            <xsl:apply-templates select="OrganizationMembership"/>
        </xsl:template>
      </xsl:stylesheet>
    XLST

## Basics

Dokumentation unter https://api-se.tournamentsoftware.com/Documentation

    curl -s -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization |  xmllint --format -

    curl -s -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization/$TS_ORGANIZATION/RootGroup |  xmllint --format -

    curl -s -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization/$TS_ORGANIZATION/Person/$TS_PERSON/Membership |  xmllint --format -


## Liste von Gruppen innerhalb der Organisation

Kann via Such Feature

    curl -s -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization/$TS_ORGANIZATION/Group |  xmllint --format -


## Gruppen POST und PUT

Kann einfach neue Gruppen anlegen (brauche aber immer die ParentGroup als param)

     curl -X POST -d "Name=test" -d "ParentCode=b8ea3aef-07b0-4981-90f3-2e6a62af9823" -s -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization/$TS_ORGANIZATION/Group

bekomme immer eine Result entity zb.

      <OrganizationGroup>
        <Code>0C568595-05D6-42AB-B688-75EBF6CC08A3</Code>
        <Number>9999</Number>
        <Name>Test Gruppe</Name>
        <Latitude>0</Latitude>
        <Longitude>0</Longitude>
        <OrganizationLevel>
          <Code>8AF9CDC4-0F80-40BD-A5E9-344AE552CCBA</Code>
          <Name>Clubs</Name>
        </OrganizationLevel>
        <ParentOrganizationGroup>
          <Code>3BD18341-2756-40B2-B94C-0170B59B7A8C</Code>
          <Number>OTH</Number>
          <Name>OtherRegion</Name>
        </ParentOrganizationGroup>
      </OrganizationGroup>


## Updating von Gruppen

Das scheint noch nicht zu funktionieren, erwarten würde ich in etwa

     curl -X POST -d "Name=test1"  -s -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization/$TS_ORGANIZATION/Group/0C568595-05D6-42AB-B688-75EBF6CC08A3

aktuell bekomme ich aber

    <?xml version="1.0" encoding="utf-8"?>
    <Result Version="1.0">
      <Error>
        <Code>2030</Code>
        <Message>Parent Code not Provided.</Message>
      </Error>
    </Result>


und wenn ich tatsächlich einen ParentCode mitgebe, dann legt er eine neue Gruppe an

    curl -s  -X PUT -d "Name=test5" -d 'ParentCode=B8EA3AEF-07B0-4981-90F3-2E6A62AF9823'  -s -u $TS_USERNAME:$TS_PASSWORD $TS_HOST/1.0/Organization/$TS_ORGANIZATION/Group/0C568595-05D6-42AB-B688-75EBF6CC08A3  | xmllint --format -
    <?xml version="1.0" encoding="utf-8"?>
    <Result Version="1.0">
      <Error>
        <Code>0</Code>
        <Message>Success</Message>
      </Error>
      <OrganizationGroup>
        <Code>E121B890-ED99-4E05-9689-8ED55B6C3457</Code>
        <Name>test5</Name>
      </OrganizationGroup>
    </Result>



## Fraglich welche entities wird tatsächlich brauchen

- Person
- Group
- Membership

## Included in MVP

- mal den namen auf allen models syncen (update)
- create / delete
- callbacks via jobs testen
- dann weitere straight foward attribute


folgendes aktuell excludiert
- kontakt syncen auf gruppe
- weitere


## Gruppen 

- parent_id auf center hard codieren? Wie sieht das dann in Prod aus?

## Rolle - Stammdaten

Behindertensport
Center Contact
Club Ausbildung
Club Breitensport
Club Diverse 1
Club Ethik
Club Events/Turniere
Club Finanzen
Club Interclub
Club J&S-Coach
Club Kommunikation
Club Kontaktadresse
Club Leistungssport
Club Marketing/Sponsoring
Club Nachwuchs
Club Nationalliga
Club Offical
Club Präsident
Club Schiedsrichter
Club Sport Integrity
Club Vize-Präsident
Clubtrainer
Ehrenmitglieder SB
J&S Experte
Kaderspieler
Nationalmannschaftstrainer
Region Breitensport
Region Ethik
Region Finanzen
Region Interclub
Region J&S-Coach
Region Kommunikation
Region Kontaktadresse
Region Marketing/Sponsoring
Region Nachwuchs
Region Offical
Region Präsident
Region Schiedsrichter
Region Sport Integrity
Schweizermeister
Shuttle Time Tutor
Spieler
Swiss Badminton Breitensport
Swiss Badminton Ethik
Swiss Badminton Finanzen
Swiss Badminton Interclub
Swiss Badminton J&S-Coach
Swiss Badminton Kommunikation
Swiss Badminton Kontaktadresse
Swiss Badminton Marketing/Sponsoring
Swiss Badminton Nachwuchs
Swiss Badminton Offical
Swiss Badminton Präsident
Swiss Badminton Schiedsrichter
Swiss Badminton Sport Integrity
Turnierorganisator
Volunteer
ZV-Mitglieder



## Membership - Stammdaten

Aktiv
Junior (U17-U19)
Junior (up to U15)
Junior Lizenz Plus (U19)
Lizenz
Lizenz NO ranking
Lizenz Plus
Passiv
Shuttletime
Vereinigungsspieler



## Personmembership - zuordnung von Person, Gruppe, Rolle, Membership
- PersonMembership (Group, Role, Membership)


