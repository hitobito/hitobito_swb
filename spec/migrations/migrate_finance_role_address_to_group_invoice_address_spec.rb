# frozen_string_literal: true

#  Copyright (c) 2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"
require_relative "../../db/migrate/20260902120000_migrate_finance_role_address_to_group_invoice_address"

describe MigrateFinanceRoleAddressToGroupInvoiceAddress do
  subject(:migration) { described_class.new.tap { |m| m.verbose = false } }

  def create_person_with(type, group)
    Fabricate(:person).tap { |person| Fabricate(type, group:, person:) }
  end

  context "Verein" do
    let(:verein) { groups(:bc_bern) }
    let(:vorstand) { groups(:bc_bern_vorstand) }

    it "copies address and email from the finance role holder" do
      person = create_person_with(Group::VereinVorstand::Finanzen.sti_name, vorstand)

      migration.up

      address = verein.additional_addresses.find_by(invoices: true)
      expect(address.label).to eq "Rechnungsadresse"
      expect(address.uses_contactable_name).to eq false
      expect(address.organization).to eq false
      expect(address.first_name).to eq person.first_name
      expect(address.last_name).to eq person.last_name
      expect(address.street).to eq person.street
      expect(address.housenumber).to eq person.housenumber
      expect(address.zip_code).to eq person.zip_code
      expect(address.town).to eq person.town
      expect(address.country).to eq person.country

      email = verein.additional_emails.find_by(invoices: true)
      expect(email.label).to eq "Rechnungsadresse"
      expect(email.email).to eq person.email
    end

    it "uses the earliest created finance role when there are several" do
      older_person = create_person_with(Group::VereinVorstand::Finanzen.sti_name, vorstand)
      vorstand.roles.find_by(person: older_person).update_column(:created_at, 2.days.ago) # rubocop:disable Rails/SkipsModelValidations
      create_person_with(Group::VereinVorstand::Finanzen.sti_name, vorstand)

      migration.up

      expect(verein.additional_emails.find_by(invoices: true).email).to eq older_person.email
      expect(verein.additional_addresses.find_by(invoices: true).street).to eq older_person.street
    end

    it "does not create anything when there is no finance role" do
      migration.up

      expect(verein.additional_addresses.where(invoices: true)).to be_empty
      expect(verein.additional_emails.where(invoices: true)).to be_empty
    end

    it "does not overwrite an already configured invoice address" do
      existing = verein.additional_addresses.create!(
        label: "Rechnungsadresse", invoices: true, uses_contactable_name: false,
        first_name: "Existing", last_name: "Person",
        street: "Altstrasse", zip_code: "1000", town: "Bern", country: "CH"
      )
      create_person_with(Group::VereinVorstand::Finanzen.sti_name, vorstand)

      migration.up

      expect(verein.additional_addresses.where(invoices: true).count).to eq 1
      expect(verein.additional_addresses.find_by(invoices: true)).to eq existing
    end

    it "does not overwrite an already configured invoice email" do
      existing = verein.additional_emails.create!(
        label: "Rechnungsadresse", invoices: true, email: "old@example.com"
      )
      create_person_with(Group::VereinVorstand::Finanzen.sti_name, vorstand)

      migration.up

      expect(verein.additional_emails.where(invoices: true).count).to eq 1
      expect(verein.additional_emails.find_by(invoices: true)).to eq existing
    end

    it "skips the address when the finance person has an incomplete address, but still migrates the email" do
      person = create_person_with(Group::VereinVorstand::Finanzen.sti_name, vorstand)
      person.update_column(:street, nil) # rubocop:disable Rails/SkipsModelValidations

      migration.up

      expect(verein.additional_addresses.where(invoices: true)).to be_empty
      expect(verein.additional_emails.find_by(invoices: true).email).to eq person.email
    end

    it "skips the email when the finance person has no email, but still migrates the address" do
      person = create_person_with(Group::VereinVorstand::Finanzen.sti_name, vorstand)
      person.update_column(:email, nil) # rubocop:disable Rails/SkipsModelValidations

      migration.up

      expect(verein.additional_emails.where(invoices: true)).to be_empty
      expect(verein.additional_addresses.find_by(invoices: true).first_name).to eq person.first_name
    end

    it "does not migrate a deleted Verein" do
      create_person_with(Group::VereinVorstand::Finanzen.sti_name, vorstand)
      verein.update_column(:deleted_at, Time.current) # rubocop:disable Rails/SkipsModelValidations

      migration.up

      expect(AdditionalAddress.where(contactable_type: "Group", contactable_id: verein.id)).to be_empty
      expect(AdditionalEmail.where(contactable_type: "Group", contactable_id: verein.id)).to be_empty
    end

    it "does not use a finance role from a deleted Vorstand" do
      create_person_with(Group::VereinVorstand::Finanzen.sti_name, vorstand)
      vorstand.update_column(:deleted_at, Time.current) # rubocop:disable Rails/SkipsModelValidations

      migration.up

      expect(verein.additional_addresses.where(invoices: true)).to be_empty
      expect(verein.additional_emails.where(invoices: true)).to be_empty
    end
  end

  context "Region" do
    let(:region) { groups(:brb) }
    let(:vorstand) { groups(:brb_vorstand) }

    it "copies address and email from the finance role holder" do
      person = create_person_with(Group::RegionVorstand::Finanzen.sti_name, vorstand)

      migration.up

      expect(region.additional_addresses.find_by(invoices: true).first_name).to eq person.first_name
      expect(region.additional_emails.find_by(invoices: true).email).to eq person.email
    end

    it "does not create anything when there is no finance role" do
      migration.up

      expect(region.additional_addresses.where(invoices: true)).to be_empty
      expect(region.additional_emails.where(invoices: true)).to be_empty
    end
  end
end
