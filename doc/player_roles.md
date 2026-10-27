# Spielerrollen und Phasen

Spielerrollen (`Role::Player`) leben in den Gruppen `VereinSpieler`, `RegionSpieler` und
`DachverbandSpieler`. Wer welche Spielerrolle wann anlegen, ändern oder löschen darf, hängt von der
aktuellen Saisonphase ab.


## Rollen

| Rolle | Klasse | Alter | Bemerkung |
|---|---|---|---|
| Aktivmitglied, Passivmitglied | `Aktivmitglied`, `Passivmitglied` | ab 19 | |
| Lizenz | `Lizenz` | ab 19 | max. eine pro Person über alle Ebenen |
| Mitgliedschaft Nachwuchs bis U15 / U17-U19 | `AktivmitgliedU15` / `U19` | bis 14 / 15-18 | ohne Wettkampf |
| Lizenz Nachwuchs bis U15 / U17-U19 | `JuniorU15` / `U19` | bis 14 / 15-18 | mit Wettkampf |
| Lizenz Plus, Lizenz Plus Nachwuchs, Lizenz NO ranking | `LizenzPlus`, `LizenzPlusJunior`, `LizenzNoRanking` | | nur im Verein, max. eine pro Person |
| Vereinigungsspieler:in | `Vereinigungsspieler` | jedes | nur im Verein |

- Pro Gruppe hat eine Person höchstens eine Spielerrolle.
- Lizenz Plus endet automatisch am `roles.lizenz.end_date` (14. Juni). Das Ende kann nur ein Admin ändern.
- `Roles::PromoterJob` stuft Junioren täglich weiter, wenn sie aus ihrer Altersklasse fallen (U15 →
  U19, danach Lizenz bzw. Passivmitglied).
- Das Alter ist das aktuelle Jahr minus Geburtsjahr (verwendet fürs Promoten und Validieren)


## Phasen

Die Phasen sind in `config/settings.yml` unter `roles.phases` konfiguriert. Admins (Permission
`:admin`) sind von allen Phasen ausgenommen.

| Phase | Zeitraum | Anlegen | Bearbeiten / Typwechsel | Löschen |
|---|---|---|---|---|
| 1 Open | 15.6.–15.8. | ja | ja | ja |
| 2 Reduced | 16.8.–31.1. | erste Rolle in der Gruppe oder Upgrade | ja, Typwechsel nur als Upgrade | nur Passivmitglied |
| 3 Restricted | 1.1.–14.6. | nur Junioren: erste Rolle oder Upgrade | nur Junioren mit möglichem Upgrade | nur Passivmitglied |

Spielertransfers in einen anderen Verein werden nur in Phase 1 angeboten.


## Upgrades

`roles.phases.upgrades` legt fest, in welche Typen eine Rolle in Phase 2 und 3 gewechselt werden darf.
Ein Wechsel in den gleichen Typ gilt immer als erlaubt. Alles andere ist ein Downgrade und nur in Phase 1
oder durch Admins möglich.

| Von | Nach |
|---|---|
| Passivmitglied | Aktivmitglied, Lizenz |
| Aktivmitglied | Lizenz |
| Mitgliedschaft Nachwuchs (U15 / U19) | Lizenz Nachwuchs derselben Altersklasse |
| Lizenz, Lizenz Plus, Lizenz Plus Nachwuchs, Lizenz NO ranking | Vereinigungsspieler:in |


## Umsetzung

`Swb::RoleAbility` fragt für Spielerrollen die aktive Phase (`Roles::Players::Phases.active`). Jede Phase
beantwortet drei Fragen:

| Frage | Subjekt | Wofür |
|---|---|---|
| `create?` | neue Rolle | Anlegen, und beim Typwechsel die neue Rolle |
| `update?` | bestehende Rolle | Formular öffnen und speichern |
| `destroy?` | bestehende Rolle | Löschen |

Core prüft `update` auch für neue Rollen, um die Typen im Dropdown des Rollenformulars zu bestimmen.
`Swb::RoleAbility` beantwortet das mit `create?`, so zeigt das Dropdown genau die Typen, die beim Speichern
erlaubt sind.
Passivmitglieder darf `Swb::RoleAbility` unabhängig von `destroy?` in jeder Phase löschen.

`Roles::Players::Checker` vergleicht den Typ der geprüften Rolle mit der bestehenden Spielerrolle der Person
in derselben Gruppe: `first_role?` (keine bestehende Rolle), `same_type?`, `upgrade?` (laut `upgrades`),
`upgradeable?` (der Typ hat Upgrades) und `junior?`.

Ein Typwechsel im Rollenformular besteht in hitobito aus zwei Prüfungen: `update?` auf der bestehenden und `create?`
auf der neuen Rolle. Ist der gewählte Typ nicht erlaubt, wird nichts geändert.
Wechselt eine Spielerrolle dabei die Gruppe, endet sie in ihrer Gruppe, deshalb braucht es zusätzlich
`destroy?` auf der bestehenden Rolle.

In Phase 3 darf ausser dem Typ nichts geändert werden (`only_type_editable?`). `Swb::RolesController`
blendet dafür für Nicht-Admins die Bezeichnung aus, ignoriert sie beim Speichern und übernimmt sie bei einem Upgrade auf die neue Rolle.
Das Enddatum ist ohne Löschrecht gesperrt.
