# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module SwbImport
  Entity = Class.new(Struct) do
    class_attribute :mappings, :non_assignable_attrs, :model_class, :ident_keys
    delegate :save, :errors, :persisted?, to: :model

    def self.from(csv_row)
      new(**Parser.new(csv_row.to_h.symbolize_keys, mappings).parse)
    end

    def valid? = model.valid?(:import)

    def to_s(details: false) = "#{status} #{model}"

    def <=>(other) = to_s <=> other.to_s

    def assignable_attrs = to_h.except(*non_assignable_attrs.to_a)

    def status = errors.none? ? "✔" : "✖"

    def full_error_messages = (errors.full_messages if errors.any?)

    def model = @model ||= build

    def build
      ident_attrs = assignable_attrs.slice(*ident_keys.to_a)
      model = ident_attrs.any? ? model_class.find_or_initialize_by(ident_attrs) : model_class.new
      model.attributes = assignable_attrs
      model.tap do |model|
        yield model if block_given?
      end
    end
  end

  module WithContact
    def people?
      return @@people if defined?(@@people)
      @@people ||= ::Person.exists?
    end

    def save
      super.then do |success|
        next success unless people? && contact
        person = ::Person.search(contact).first
        person ? create_contact_role_and_update_group(person) : true
      end
    end

    def create_contact_role_and_update_group(person)
      person.roles.find_or_create_by!(type: "#{model.class.name}::Administrator", group: model) &&
        model.update_columns(contact_id: person.id) # avoids callbacks to not trigger double creation of default children
    end

    def build_contact(model, person)
      return unless person

      model.contact = person
      model.roles.find_or_initialize_by(type: "#{model.class.name}::Administrator", person:)
    end
  end

  Region = Entity.new(*REGION_MAPPINGS.map(&:second), keyword_init: true) do
    prepend WithContact
    self.mappings = REGION_MAPPINGS
    self.non_assignable_attrs = [:phone, :phone2, :mobile, :website, :contact]
    self.model_class = Group::Region
    self.ident_keys = [:ts_code]

    def self.root_id = @root_id ||= Group.root.id

    def build
      super do |model|
        model.parent_id = self.class.root_id
        model.phone_numbers.build(label: :landline, number: phone || phone2) if [phone, phone2].any?(&:present?)
        model.phone_numbers.build(label: :mobile, number: mobile) if mobile
        model.social_accounts.build(label: :website, name: website) if website
      end
    end

    def to_s(details: false) = ["#{status} #{model} (#{model.short_name})", (full_error_messages if details)].compact_blank.join(": ")
  end

  Club = Entity.new(*CLUB_MAPPINGS.map(&:second), keyword_init: true) do
    prepend WithContact
    delegate :type, to: :model

    self.mappings = CLUB_MAPPINGS
    self.non_assignable_attrs = [:phone, :phone2, :mobile, :website, :contact, :parent_number]
    self.ident_keys = [:ts_code]

    def self.root = @root ||= Group.root

    def to_s(details: false) = ["#{status} #{model} (#{model.id})", (full_error_messages if details)].compact_blank.join(": ")

    def build
      super do |model|
        model.parent = model.is_a?(Group::Center) ? self.class.root : Group::Region.find_by(short_name: parent_number)
        model.phone_numbers.build(label: :landline, number: phone || phone2) if [phone, phone2].any?(&:present?)
        model.phone_numbers.build(label: :mobile, number: mobile) if mobile
        model.social_accounts.build(label: :website, name: website) if website
      end
    end

    def model_class = (parent_number == CENTER_PARENT_NUMBER) ? Group::Center : Group::Verein
  end

  Person = Entity.new(*PERSON_MAPPINGS.map(&:second), keyword_init: true) do
    self.mappings = PERSON_MAPPINGS
    self.non_assignable_attrs = [:phone, :mobile]
    self.model_class = ::Person
    self.ident_keys = [:ts_code]

    def save
      return model.save.tap { emails[email] = id } if new_email?

      model.additional_emails.build(email: email, label: "Andere")
      model.email = nil
      model.save
    end

    def new_email?
      @@emails ||= {}
      @@emails.key?(email)
    end

    def build
      super do |model|
        model.phone_numbers.build(label: :mobile, number: mobile) if mobile
        model.phone_numbers.build(label: :landline, number: phone) if phone
      end
    end

    def to_s(details: false)
      values = to_h.except(:id, :first_name, :last_name).values.join(",")
      ["#{status} #{model} (#{details ? [id, values].join(",") : id})", (full_error_messages if details)].compact_blank.join(": ")
    end
  end

  Role = Entity.new(*ROLE_MAPPINGS.map(&:second), keyword_init: true) do
    self.mappings = ROLE_MAPPINGS
    self.model_class = ::Role
    self.non_assignable_attrs = [:role, :spieler_role_type, :groupnumber]
    self.ident_keys = [:person_id, :group_id, :type]

    def build
      super do |role|
        role.group_id = find_group_id
        role.type = find_role_type
      end
    end

    def to_s(details: false)
      values = to_h.slice(*non_assignable_attrs).values.join(",")
      ["#{status} #{person} #{model} (#{details ? [values].join(",") : role})", (full_error_messages if details)].compact_blank.join(": ")
    end

    def person = people[person_id] || person_id

    def region_ids = @@region_ids ||= Group::Region.pluck(:short_name, :id).to_h

    def find_role_type = SPIELER_LIZENZ_MAPPING[spieler_role_type] || ROLE_TYPE_MAPPING[role]

    # This builds a complex map in the form of layer_id => { role_type => group_id }
    # We need that because roles are assigned on layer in input data
    def group_ids = @@group_ids ||= Group.order(:id)
      .pluck(:layer_group_id, :type, :id)
      .group_by(&:shift).transform_values { |list| list.flat_map { |g, id| g.constantize.role_types.map(&:to_s).product([id]) }.to_h }

    def people = @@people ||= ::Person.pluck(:id, :first_name, :last_name)
      .map { |id, first_name, last_name| [id, "#{first_name} #{last_name} (#{id})"] }
      .to_h

    # cater for mixed values in groupnumber field
    def find_group_id
      return region_ids[groupnumber] if groupnumber[/[a-zA-Z]/]

      group_ids.dig(Integer(groupnumber), find_role_type&.sti_name)
    end
  end
end
