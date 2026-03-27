# frozen_string_literal: true

#  Copyright (c) 2026, BdP and DPSG. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require "spec_helper"

describe PeriodInvoiceTemplates::InvoiceRunsController, js: true do
  subject { page }

  let(:user) { people(:leader) }
  let!(:finance_role) { Group::DachverbandGeschaeftsstelle::Finanzen.create!(person: user, group: groups(:root_gs)) }
  let(:group) { groups(:root) }
  let(:index_path) { group_period_invoice_template_invoice_runs_path(group, period_invoice_template) }

  before do
    sign_in(user)
  end

  context "Regionen" do
    let(:period_invoice_template) { period_invoice_templates(:regionen) }

    let!(:regions) do
      [:de, :fr, :en].map do |lang|
        Fabricate(Group::Region.name, parent: groups(:root), language: lang, street: "Rue des rues",
          zip_code: 1000, town: "Ville des villes")
      end
    end

    it "generates the invoices" do
      visit index_path
      click_link "Rechnungslauf fahren"

      expect(page).to have_text "Hinweis: Falls die Filterbedingungen"

      fill_in "Titel", with: "Testlauf"
      first("button[data-bs-title*=\"weitere verfügbare Sprachen\"]").click
      first("input[name*=title_fr]").fill_in with: "Test FR"
      click_button "Speichern"

      expect(page).to have_text "Rechnung Testlauf wurde für 5 Empfänger erstellt."
      expect(page).to have_text "Für 2 Empfänger konnte keine gültige Rechnung erzeugt werden."
      expect(page).to have_text "Badminton Regionalverband Bern, Badminton Verband Nordwestschweiz"
      expect(page).to have_text "3 Rechnungen angezeigt."
      expect(page).to have_text "Testlauf"
      expect(page).to have_text "Test FR"
      expect(page).to have_text regions[0].name
      expect(page).to have_text regions[1].name
      expect(page).to have_text regions[2].name
      expect(page).to have_text "500.00 CHF"

      click_link "Test FR"
      expect(page).to have_text "Rechnung stellen / mahnen"
      click_link "FR"
      expect(page).to have_text "Test FR"
      expect(page).to have_text "Cotisation de région"
      expect(page).not_to have_text "Grundbeitrag Region"
      expect(page).not_to have_text "Testlauf"

      # In the meantime, new regions are added to hitobito
      new_1 = Fabricate(Group::Region.name, parent: groups(:root), street: "Rue des rues",
        zip_code: 1000, town: "Ville des villes")
      new_2 = Fabricate(Group::Region.name, parent: groups(:root), street: "Rue des rues",
        zip_code: 1000, town: "Ville des villes")

      # Follow-up invoice run
      # Should only include the one new added role and ignore the previously invoiced ones.
      # Should not create any invoice for layers which contain no invoiceable roles at all.

      visit index_path
      click_link "Rechnungslauf fahren"

      expect(page).to have_text "Hinweis: Falls die Filterbedingungen"
      expect(page).to have_text "500.00 CHF"

      fill_in "Titel", with: "Zweiter Testlauf"
      click_button "Speichern"

      expect(page).to have_text "Rechnung Zweiter Testlauf wurde für 7 Empfänger erstellt."
      expect(page).to have_text "2 Rechnungen angezeigt."
      expect(page).not_to have_text "Test FR"
      expect(page).not_to have_text regions[0].name
      expect(page).not_to have_text regions[1].name
      expect(page).not_to have_text regions[2].name
      expect(page).to have_text new_1.name
      expect(page).to have_text new_2.name
      expect(page).to have_text "500.00 CHF"
    end
  end
end
