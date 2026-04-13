# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

InvoiceConfig.seed(:group_id,
  group_id: Group.root.id,
  iban: "CH93 0076 2011 6238 5295 7",
  payee: <<~TEXT
    Swiss Badminton
    Talgut-Zentrum 27
    3063 Ittigen - CH
  TEXT
)

regionen_recipients = GroupsFilter.seed({
  group_type: "Group::Region",
  parent_id: Group.root.id
}).first
regionen = PeriodInvoiceTemplate.seed(:name, {
  name: "Regionen 2026",
  start_on: "2026-01-01",
  end_on: "2026-12-31",
  group_id: Group.root.id,
  recipient_source_id: regionen_recipients.id,
  recipient_source_type: "GroupsFilter"
}).first
PeriodInvoiceTemplate::RegionItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3000",
  dynamic_cost_parameters: {
    unit_cost: "500.00"
  },
  period_invoice_template_id: regionen.id
}).first.update!(name: "Grundbeitrag Region", name_fr: "Cotisation de région")

teams_recipients = GroupsFilter.seed({
  group_type: "Group::Verein",
  parent_id: Group.root.id
}).first
teams = PeriodInvoiceTemplate.seed(:name, {
  name: "Teams 2026",
  start_on: "2026-01-01",
  end_on: "2026-12-31",
  group_id: Group.root.id,
  recipient_source_id: teams_recipients.id,
  recipient_source_type: "GroupsFilter"
}).first
PeriodInvoiceTemplate::VereinItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3000",
  dynamic_cost_parameters: {
    unit_cost: "300.00"
  },
  period_invoice_template_id: teams.id
}).first.update!(name: "Grundbeitrag", name_fr: "Cotisation de club")
PeriodInvoiceTemplate::VereinReducedItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3000",
  dynamic_cost_parameters: {
    unit_cost: "30.00"
  },
  period_invoice_template_id: teams.id
}).first.update!(name: "Grundbeitrag reduziert", name_fr: "Cotisation réduite de club")
PeriodInvoiceTemplate::TeamItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3000",
  dynamic_cost_parameters: {
    unit_cost: "1000.00",
    leagues: ["NLA"],
  },
  period_invoice_template_id: teams.id
}).first.update!(name: "NLA", name_fr: "LNA")
PeriodInvoiceTemplate::TeamItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3000",
  dynamic_cost_parameters: {
    unit_cost: "800.00",
    leagues: ["NLB"],
  },
  period_invoice_template_id: teams.id
}).first.update!(name: "NLB", name_fr: "LNB")
PeriodInvoiceTemplate::TeamItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3000",
  dynamic_cost_parameters: {
    unit_cost: "600.00",
    leagues: ["1. Liga"],
  },
  period_invoice_template_id: teams.id
}).first.update!(name: "1. Liga", name_fr: "1ère ligue")
PeriodInvoiceTemplate::TeamItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3000",
  dynamic_cost_parameters: {
    unit_cost: "500.00",
    leagues: ["2. Liga"],
  },
  period_invoice_template_id: teams.id
}).first.update!(name: "2. Liga", name_fr: "2e ligue")
PeriodInvoiceTemplate::TeamItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3000",
  dynamic_cost_parameters: {
    unit_cost: "250.00",
    leagues: ["3. Liga"],
  },
  period_invoice_template_id: teams.id
}).first.update!(name: "3. Liga", name_fr: "3e ligue")
PeriodInvoiceTemplate::TeamItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3000",
  dynamic_cost_parameters: {
    unit_cost: "250.00",
    leagues: ["4. Liga"],
  },
  period_invoice_template_id: teams.id
}).first.update!(name: "4. Liga", name_fr: "4e ligue")
PeriodInvoiceTemplate::TeamItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3000",
  dynamic_cost_parameters: {
    unit_cost: "20.00",
    leagues: ["Junioren", "Senioren", "NL - 5. Liga"],
  },
  period_invoice_template_id: teams.id
}).first.update!(name: "Junioren, Senioren und 5. Liga Teams", name_fr: "Equipes juniores, séniores et 5e ligue")
PeriodInvoiceTemplate::TeamItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3000",
  dynamic_cost_parameters: {
    unit_cost: "300.00",
    leagues: ["Vereinigung"],
  },
  period_invoice_template_id: teams.id
}).first.update!(name: "Vereinigung", name_fr: "Union")

roles_source = GroupsFilter.seed({
  group_type: "Group::Verein",
  parent_id: Group.root.id
}).first
roles = PeriodInvoiceTemplate.seed(:name, {
  name: "Spieler 2026",
  start_on: "2026-01-01",
  end_on: "2026-12-31",
  group_id: Group.root.id,
  recipient_source_id: roles_source.id,
  recipient_source_type: "GroupsFilter"
}).first
PeriodInvoiceTemplate::RoleCountItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3003",
  dynamic_cost_parameters: {
    unit_cost: "30.00",
    role_types: ["Group::VereinSpieler::Aktivmitglied"],
  },
  period_invoice_template_id: roles.id
}).first.update!(name: "Aktivmitglieder", name_fr: "Membres actifs")
PeriodInvoiceTemplate::RoleCountItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3003",
  dynamic_cost_parameters: {
    unit_cost: "0.00",
    role_types: ["Group::VereinSpieler::Passivmitglied"],
  },
  period_invoice_template_id: roles.id
}).first.update!(name: "Passivmitglieder", name_fr: "Membres passif")
PeriodInvoiceTemplate::RoleCountItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3003",
  dynamic_cost_parameters: {
    unit_cost: "20.00",
    role_types: ["Group::VereinSpieler::JuniorU15"],
  },
  period_invoice_template_id: roles.id
}).first.update!(name: "Junior:innen (bis U15)", name_fr: "Junior.e.s (jusqu'à U15)")
PeriodInvoiceTemplate::RoleCountItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3003",
  dynamic_cost_parameters: {
    unit_cost: "40.00",
    role_types: ["Group::VereinSpieler::JuniorU19"],
  },
  period_invoice_template_id: roles.id
}).first.update!(name: "Junior:innen (U17-U19)", name_fr: "Junior.e.s (U17-U19)")
PeriodInvoiceTemplate::RoleCountItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3003",
  dynamic_cost_parameters: {
    unit_cost: "120.00",
    role_types: ["Group::VereinSpieler::Lizenz"],
  },
  period_invoice_template_id: roles.id
}).first.update!(name: "Lizenzen", name_fr: "Licences")
PeriodInvoiceTemplate::RoleCountItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3003",
  dynamic_cost_parameters: {
    unit_cost: "50.00",
    role_types: ["Group::VereinSpieler::LizenzPlus"],
  },
  period_invoice_template_id: roles.id
}).first.update!(name: "Lizenzen Plus", name_fr: "Licences Plus")
PeriodInvoiceTemplate::RoleCountItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3003",
  dynamic_cost_parameters: {
    unit_cost: "120.00",
    role_types: ["Group::VereinSpieler::LizenzNoRanking"],
  },
  period_invoice_template_id: roles.id
}).first.update!(name: "Lizenzen NO ranking", name_fr: "Lizenzen NO ranking")
PeriodInvoiceTemplate::RoleCountItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3003",
  dynamic_cost_parameters: {
    unit_cost: "20.00",
    role_types: ["Group::VereinSpieler::LizenzPlusJunior"],
  },
  period_invoice_template_id: roles.id
}).first.update!(name: "Lizenzen Plus Junior:innen (U19)", name_fr: "Licences plus junior.e.s (U19)")
PeriodInvoiceTemplate::RoleCountItem.seed({
  account: "CH56 0483 5035 4099 6000 0",
  cost_center: "3003",
  dynamic_cost_parameters: {
    unit_cost: "0.00",
    role_types: ["Group::VereinSpieler::Vereinigungsspieler"],
  },
  period_invoice_template_id: roles.id
}).first.update!(name: "Vereinigungsspieler:innen", name_fr: "Joueur.se.s d'une union")
