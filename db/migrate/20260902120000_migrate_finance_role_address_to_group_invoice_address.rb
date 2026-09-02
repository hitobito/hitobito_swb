# frozen_string_literal: true

#  Copyright (c) 2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class MigrateFinanceRoleAddressToGroupInvoiceAddress < ActiveRecord::Migration[8.0] # rubocop:disable Rails/ReversibleMigrationMethodDefinition
  FINANZEN_ROLE_TYPES = %w[
    Group::VereinVorstand::Finanzen
    Group::RegionVorstand::Finanzen
  ].freeze

  TARGET_GROUP_TYPES = %w[Group::Verein Group::Region].freeze

  def up
    say_with_time "copying finance role address/email to group invoice contact" do
      insert_missing_addresses
      insert_missing_emails
    end

    report_migration_summary
  end

  private

  def insert_missing_addresses
    already_has = invoice_contact_group_ids(AdditionalAddress)
    rows = finance_person_by_group_id.filter_map do |group_id, person|
      address_attributes(group_id, person) unless already_has.include?(group_id)
    end
    AdditionalAddress.insert_all(rows) if rows.any?
  end

  def insert_missing_emails
    already_has = invoice_contact_group_ids(AdditionalEmail)
    rows = finance_person_by_group_id.filter_map do |group_id, person|
      email_attributes(group_id, person) unless already_has.include?(group_id)
    end
    AdditionalEmail.insert_all(rows) if rows.any?
  end

  def finance_person_by_group_id
    @finance_person_by_group_id ||= begin
      person_id_by_group_id = Role.joins(:group)
        .where(type: FINANZEN_ROLE_TYPES, groups: {deleted_at: nil})
        .order("groups.layer_group_id", "roles.created_at")
        .pluck("groups.layer_group_id", "roles.person_id")
        .each_with_object({}) { |(group_id, person_id), result| result[group_id] ||= person_id }
        .slice(*target_groups.keys)

      people = Person.where(id: person_id_by_group_id.values).index_by(&:id)
      person_id_by_group_id.filter_map { |group_id, person_id|
        [group_id, people[person_id]] if people[person_id]
      }.to_h
    end
  end

  def target_groups
    @target_groups ||= Group.without_deleted.where(type: TARGET_GROUP_TYPES).pluck(:id, :name).to_h
  end

  def invoice_contact_group_ids(klass)
    klass.where(contactable_type: Group.sti_name, invoices: true).pluck(:contactable_id).to_set
  end

  def address_attributes(group_id, person)
    return if [person.street, person.zip_code, person.town, person.country].any?(&:blank?)

    person.attributes.symbolize_keys
      .slice(:address_care_of, :street, :housenumber, :postbox, :zip_code, :town, :country)
      .merge(
        contactable_type: Group.sti_name,
        contactable_id: group_id,
        label: "Rechnungsadresse",
        invoices: true,
        uses_contactable_name: false,
        first_name: person.first_name,
        last_name: person.last_name,
        organization: person.company,
        organization_name: person.company_name
      )
  end

  def email_attributes(group_id, person)
    return if person.email.blank?

    {
      contactable_type: Group.sti_name,
      contactable_id: group_id,
      label: "Rechnungsadresse",
      invoices: true,
      email: person.email
    }
  end

  def report_migration_summary
    address_ids = invoice_contact_group_ids(AdditionalAddress)
    email_ids = invoice_contact_group_ids(AdditionalEmail)

    successful = target_groups.count do |id, _name|
      address_ids.include?(id) && email_ids.include?(id)
    end
    say "Successfully migrated groups: #{successful}"

    report_missing(target_groups, address_ids, "invoice address")
    report_missing(target_groups, email_ids, "invoice email")
  end

  def report_missing(group_name_by_id, covered_ids, label)
    missing = group_name_by_id.except(*covered_ids)

    say "Groups missing #{label}: #{missing.size}"
    missing.each { |id, name| say "#{name} (##{id})", true }
  end
end
