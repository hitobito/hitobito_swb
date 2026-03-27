# frozen_string_literal: true

#  Copyright (c) 2026, BdP and DPSG. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require "spec_helper"

describe PeriodInvoiceTemplatesController, js: true do
  subject { page }

  let(:user) { people(:leader) }
  let!(:finance_role) { Group::DachverbandGeschaeftsstelle::Finanzen.create!(person: user, group: groups(:root_gs)) }
  let(:group) { groups(:root) }

  before do
    sign_in(user)
    @item_count = 0
  end

  context "Regionen" do
    let(:new_path) { new_group_period_invoice_template_path(group) }

    it "can create period invoice template for regions fee" do
      visit new_path

      with_basic_info(name: "Regionen 2026", period_start_on: "1.1.2026", period_end_on: "31.12.2026",
        recipient_group_type: "Regionen") do
        add_item("Grundbeitrag Region", name_de: "Grundbeitrag Region",
          name_fr: "Cotisation de région", unit_cost: 500, cost_center: "3000",
          account: "CH56 0483 5035 4099 6000 0")
      end

      click_button "Speichern"

      expect(page).to have_text "Sammelrechnung Regionen 2026 wurde erfolgreich erstellt"
      entry = group.period_invoice_templates.last
      expect(entry).not_to be_nil
      expect(entry.recipient_source.group_type).to eq "Group::Region"
      expect(entry.recipient_source.parent_id).to eq group.id
      expect(entry.items.length).to be 1
      expect(entry.items[0].type).to eq("PeriodInvoiceTemplate::RegionItem")
      expect(entry.items[0].name).to eq("Grundbeitrag Region")
      expect(entry.items[0].name_fr).to eq("Cotisation de région")
      expect(entry.items[0].dynamic_cost_parameters[:unit_cost]).to eq("500.00")
    end
  end

  context "Teams" do
    let(:new_path) { new_group_period_invoice_template_path(group) }

    it "can create period invoice template for teams fee" do
      visit new_path

      with_basic_info(name: "Teams 2026", period_start_on: "1.1.2026", period_end_on: "31.12.2026",
        recipient_group_type: "Vereine") do
        add_item("Grundbeitrag Verein", name_de: "Grundbeitrag",
          name_fr: "Cotisation de club", unit_cost: 300, cost_center: "3000",
          account: "CH56 0483 5035 4099 6000 0")
        add_item("Grundbeitrag Verein reduziert", name_de: "Grundbeitrag reduziert",
          name_fr: "Cotisation réduite de club", unit_cost: 30, cost_center: "3000",
          account: "CH56 0483 5035 4099 6000 0")
        add_item("Teambeitrag", name_de: "NLA", name_fr: "LNA",
          unit_cost: 1000, cost_center: "3000", account: "CH56 0483 5035 4099 6000 0") do
          check "NLA"
        end
        add_item("Teambeitrag", name_de: "NLB", name_fr: "LNB",
          unit_cost: 800, cost_center: "3000", account: "CH56 0483 5035 4099 6000 0") do
          check "NLB"
        end
        add_item("Teambeitrag", name_de: "1. Liga", name_fr: "1ère ligue",
          unit_cost: 600, cost_center: "3000", account: "CH56 0483 5035 4099 6000 0") do
          check "1. Liga"
        end
        add_item("Teambeitrag", name_de: "2. Liga", name_fr: "2e ligue",
          unit_cost: 500, cost_center: "3000", account: "CH56 0483 5035 4099 6000 0") do
          check "2. Liga"
        end
        add_item("Teambeitrag", name_de: "3. Liga", name_fr: "3e ligue",
          unit_cost: 250, cost_center: "3000", account: "CH56 0483 5035 4099 6000 0") do
          check "3. Liga"
        end
        add_item("Teambeitrag", name_de: "4. Liga", name_fr: "4e ligue",
          unit_cost: 250, cost_center: "3000", account: "CH56 0483 5035 4099 6000 0") do
          check "4. Liga"
        end
        add_item("Teambeitrag", name_de: "Junioren, Senioren und 5. Liga Teams",
          name_fr: "Equipes juniores, séniores et 5e ligue", unit_cost: 20, cost_center: "3000",
          account: "CH56 0483 5035 4099 6000 0") do
          check "Junioren"
          check "Senioren"
          check "NL - 5. Liga"
        end
        add_item("Teambeitrag", name_de: "Vereinigung", name_fr: "Union",
          unit_cost: 300, cost_center: "3000", account: "CH56 0483 5035 4099 6000 0") do
          check "Vereinigung"
        end
      end

      click_button "Speichern"

      expect(page).to have_text "Sammelrechnung Teams 2026 wurde erfolgreich erstellt"
      entry = group.period_invoice_templates.last
      expect(entry).not_to be_nil
      expect(entry.recipient_source.group_type).to eq "Group::Verein"
      expect(entry.recipient_source.parent_id).to eq group.id
      expect(entry.items.length).to be 10
      expect(entry.items.map(&:type)).to eq(["PeriodInvoiceTemplate::VereinItem",
        "PeriodInvoiceTemplate::VereinReducedItem"] + Array.new(8, "PeriodInvoiceTemplate::TeamItem"))
      expect(entry.items.map(&:name)).to eq(["Grundbeitrag", "Grundbeitrag reduziert", "NLA", "NLB", "1. Liga",
        "2. Liga", "3. Liga", "4. Liga", "Junioren, Senioren und 5. Liga Teams", "Vereinigung"])
      expect(entry.items.map(&:name_fr)).to eq(["Cotisation de club", "Cotisation réduite de club", "LNA", "LNB",
        "1ère ligue", "2e ligue", "3e ligue", "4e ligue", "Equipes juniores, séniores et 5e ligue", "Union"])
      expect(entry.items.map { |item|
        item.dynamic_cost_parameters[:unit_cost]
      }).to eq(["300.00", "30.00", "1000.00", "800.00", "600.00", "500.00",
        "250.00", "250.00", "20.00", "300.00"])
      expect(entry.items.map { |item|
        item.dynamic_cost_parameters[:leagues] if item.dynamic_cost_parameters[:leagues]&.length == 1
      }).to eq([nil, nil, ["NLA"], ["NLB"], ["1. Liga"], ["2. Liga"],
        ["3. Liga"], ["4. Liga"], nil, ["Vereinigung"]])
      expect(entry.items[8].dynamic_cost_parameters[:leagues]).to match_array(["Junioren", "Senioren", "NL - 5. Liga"])
    end
  end

  context "Spieler" do
    let(:new_path) { new_group_period_invoice_template_path(group) }

    it "can create period invoice template for players fee" do
      visit new_path

      with_basic_info(name: "Spieler 2026", period_start_on: "1.1.2026", period_end_on: "31.12.2026",
        recipient_group_type: "Vereine") do
        add_item("Rollen-Zählung", name_de: "Aktivmitglieder",
          name_fr: "Membres actifs", unit_cost: 30, cost_center: "3003",
          account: "CH56 0483 5035 4099 6000 0") do
          select_role_type("Aktivmitglied")
        end
        add_item("Rollen-Zählung", name_de: "Passivmitglieder",
          name_fr: "Membres passif", unit_cost: 0, cost_center: "3003",
          account: "CH56 0483 5035 4099 6000 0") do
          select_role_type("Passivmitglied")
        end
        add_item("Rollen-Zählung", name_de: "Junior:innen (bis U15)",
          name_fr: "Junior.e.s (jusqu'à U15)", unit_cost: 20, cost_center: "3003",
          account: "CH56 0483 5035 4099 6000 0") do
          select_role_type("Junior:in (bis U15) (TS)")
        end
        add_item("Rollen-Zählung", name_de: "Junior:innen (U17-U19)",
          name_fr: "Junior.e.s (U17-U19)", unit_cost: 40, cost_center: "3003",
          account: "CH56 0483 5035 4099 6000 0") do
          select_role_type("Junior:in (U17-U19) (TS)")
        end
        add_item("Rollen-Zählung", name_de: "Lizenzen",
          name_fr: "Licences", unit_cost: 120, cost_center: "3003",
          account: "CH56 0483 5035 4099 6000 0") do
          select_role_type("Lizenz (TS)")
        end
        add_item("Rollen-Zählung", name_de: "Lizenzen Plus",
          name_fr: "Licences Plus", unit_cost: 50, cost_center: "3003",
          account: "CH56 0483 5035 4099 6000 0") do
          select_role_type("Lizenz Plus (TS)")
        end
        add_item("Rollen-Zählung", name_de: "Lizenzen NO ranking",
          name_fr: "Lizenzen NO ranking", unit_cost: 120, cost_center: "3003",
          account: "CH56 0483 5035 4099 6000 0") do
          select_role_type("Lizenz NO ranking (TS)")
        end
        add_item("Rollen-Zählung", name_de: "Lizenzen Plus Junior:innen (U19)",
          name_fr: "Licences plus junior.e.s (U19)", unit_cost: 20, cost_center: "3003",
          account: "CH56 0483 5035 4099 6000 0") do
          select_role_type("Lizenz Plus Junior:innen (U19) (TS)")
        end
        add_item("Rollen-Zählung", name_de: "Vereinigungsspieler:innen",
          name_fr: "Joueur.se.s d'une union", unit_cost: 0, cost_center: "3003",
          account: "CH56 0483 5035 4099 6000 0") do
          select_role_type("Vereinigungsspieler:in (TS)")
        end
      end

      click_button "Speichern"

      expect(page).to have_text "Sammelrechnung Spieler 2026 wurde erfolgreich erstellt"
      entry = group.period_invoice_templates.last
      expect(entry).not_to be_nil
      expect(entry.recipient_source.group_type).to eq "Group::Verein"
      expect(entry.recipient_source.parent_id).to eq group.id
      expect(entry.items.length).to be 9
      expect(entry.items.map(&:type)).to eq(Array.new(9, "PeriodInvoiceTemplate::RoleCountItem"))
      expect(entry.items.map(&:name)).to eq(["Aktivmitglieder", "Passivmitglieder", "Junior:innen (bis U15)",
        "Junior:innen (U17-U19)", "Lizenzen", "Lizenzen Plus", "Lizenzen NO ranking",
        "Lizenzen Plus Junior:innen (U19)", "Vereinigungsspieler:innen"])
      expect(entry.items.map(&:name_fr)).to eq(["Membres actifs", "Membres passif", "Junior.e.s (jusqu'à U15)",
        "Junior.e.s (U17-U19)", "Licences", "Licences Plus", "Lizenzen NO ranking", "Licences plus junior.e.s (U19)",
        "Joueur.se.s d'une union"])
      expect(entry.items.map { |item|
        item.dynamic_cost_parameters[:unit_cost]
      }).to eq(["30.00", "0.00", "20.00", "40.00", "120.00", "50.00", "120.00", "20.00", "0.00"])
      expect(entry.items.map { |item|
        item.dynamic_cost_parameters[:role_types]
      }).to eq([
        ["Group::VereinSpieler::Aktivmitglied"],
        ["Group::VereinSpieler::Passivmitglied"],
        ["Group::VereinSpieler::JuniorU15"],
        ["Group::VereinSpieler::JuniorU19"],
        ["Group::VereinSpieler::Lizenz"],
        ["Group::VereinSpieler::LizenzPlus"],
        ["Group::VereinSpieler::LizenzNoRanking"],
        ["Group::VereinSpieler::LizenzPlusJunior"],
        ["Group::VereinSpieler::Vereinigungsspieler"]
      ])
    end
  end

  def with_basic_info(name: nil, period_start_on: nil, period_end_on: nil, recipient_group_type: nil)
    fill_in "Bezeichnung", with: name if name
    fill_in "Rechnungsperiode Start", with: period_start_on if period_start_on
    fill_in "Rechnungsperiode Ende", with: period_end_on if period_end_on

    yield

    # Do this last, because it reloads the invoice items from the server.
    # Depending on the speed of the server, either the old or the new form
    # contents could be present in the page after this selection. In the UI,
    # we have no easy way of seeing this change happen, and so capybara's
    # built in waiting cannot be used here.
    select recipient_group_type, from: "Empfängergruppen" if recipient_group_type
  end

  def add_item(type, name_de: nil, name_fr: nil, unit_cost: nil, vat_rate: nil, cost_center: nil,
    account: nil)
    @item_count += 1
    click_link "Rechnungsposten hinzufügen"
    click_link type
    expect(page).to have_text "Entfernen", count: @item_count

    within all("#items_fields .fields").last do
      set_item_fields(name_de:, name_fr:, unit_cost:, vat_rate:, cost_center:, account:)
      yield if block_given?
    end
  end

  def set_item_fields(name_de: nil, name_fr: nil, unit_cost: nil, vat_rate: nil, cost_center: nil,
    account: nil)
    fill_in "Name*", with: name_de

    find("[data-bs-title^=Eingabefelder]").click
    expect(page).to have_selector("[placeholder=\"Name*\"]", count: 4)
    all("[placeholder=\"Name*\"]")[2].fill_in with: name_fr

    fill_in "Preis*", with: unit_cost
    fill_in "MwSt.", with: vat_rate
    fill_in "Kostenstelle", with: cost_center
    fill_in "Konto", with: account
  end

  def select_role_type(type)
    click_button "Rollentypen auswählen"
    expect(page).to have_content "Schliessen"
    all("label", text: type).last.check
    click_button "Schliessen"
    expect(page).to have_no_content "Schliessen"
    expect(page).to have_content type
  end
end
