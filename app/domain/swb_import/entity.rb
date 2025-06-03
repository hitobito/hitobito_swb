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
      reset!
      new(**Parser.new(csv_row.to_h.symbolize_keys, mappings).parse)
    end

    # noop
    def self.reset!
    end

    def save
      model.save(context: :import)
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

  Region = Entity.new(*REGION_MAPPINGS.map(&:second), keyword_init: true) do
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
    delegate :type, to: :model

    self.mappings = CLUB_MAPPINGS
    self.non_assignable_attrs = [:phone, :phone2, :mobile, :website, :contact, :parent_number]
    self.ident_keys = [:ts_code]

    def self.root = @root ||= Group.root

    def to_s(details: false) = ["#{status} #{model} (#{model.id})", (full_error_messages if details)].compact_blank.join(": ")

    def build
      super do |model|
        model.parent = model.is_a?(Group::Verein) ? Group::Region.find_by(short_name: parent_number) : self.class.root
        model.phone_numbers.build(label: :landline, number: phone || phone2) if [phone, phone2].any?(&:present?)
        model.phone_numbers.build(label: :mobile, number: mobile) if mobile
        model.social_accounts.build(label: :website, name: website) if website
      end
    end

    def model_class
      return Group::Verein unless parent_number == CENTER_PARENT_NUMBER
      return Group::Center if name.starts_with?(".")

      Group::CenterUnaffilliated
    end
  end

  Team = Entity.new(*TEAM_MAPPING.map(&:second), keyword_init: true) do
    self.mappings = TEAM_MAPPING
    self.ident_keys = [:name, :year]
    self.model_class = Team

    def to_h
      super.merge(year: Time.zone.today.year)
    end

    def to_s(details: false)
      values = to_h.except(:name).values.join(",")
      ["#{status} #{model} (#{details ? [name, values].join(",") : name})", (full_error_messages if details)].compact_blank.join(": ")
    end
  end

  TeamJun = Class.new(Team) do
    self.mappings = TEAM_MAPPING_JUN
  end

  TeamSen = Class.new(Team) do
    self.mappings = TEAM_MAPPING_SEN
  end

  Person = Entity.new(*PERSON_MAPPINGS.map(&:second), keyword_init: true) do
    self.mappings = PERSON_MAPPINGS
    self.non_assignable_attrs = [:phone, :mobile]
    self.model_class = ::Person
    self.ident_keys = [:ts_code]

    @@emails = {}

    def self.reset!
      @@emails = ::Person.where.not(email: nil).pluck(:email, :id).to_h
    end

    def save
      return super.tap { emails[email] = id } if new_email?

      model.additional_emails.build(email: email, label: "Andere")
      model.email = nil
      super
    end

    def <=>(other)
      if birthday && other.birthday
        birthday <=> other.birthday
      else
        to_s <=> other.to_s
      end
    end

    def emails = @@emails

    def new_email? = !emails.key?(email)

    def build
      super do |model|
        model.phone_numbers.find_or_initialize_by(label: :mobile, number: mobile) if mobile
        model.phone_numbers.find_or_initialize_by(label: :landline, number: phone) if phone
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
    self.non_assignable_attrs = [:role, :spieler_role_type, :groupcode]
    self.ident_keys = [:person_id, :group_id, :type]

    def build
      super do |role|
        type, group_id = group_ids.fetch(groupcode.downcase, {}).find { |type, _| role_types.include?(type) }

        role.group_id = group_id
        role.type = type

        role.ts_code = nil if type && type.constantize.model_name.ts_role.blank?
      end
    end

    def to_s(details: false)
      values = to_h.slice(*non_assignable_attrs).values.join(",")
      values += ",#{group_types[groupcode]}" if details
      ["#{status} #{person} #{model} (#{details ? [values].join(",") : role})", (full_error_messages if details)].compact_blank.join(": ")
    end

    def role_types
      (Array(ROLE_TYPE_MAPPING[role]) + Array(SPIELER_LIZENZ_MAPPING[spieler_role_type])).compact_blank.map(&:to_s)
    end

    def person = people[person_id] || person_id

    def find_group_id = group_ids.dig(groupcode.downcase, find_role_type&.sti_name)

    def find_role_type = SPIELER_LIZENZ_MAPPING[spieler_role_type] || ROLE_TYPE_MAPPING[role]

    def group_types = @@group_types ||= Group.pluck(:ts_code, :type).to_h

    # This builds a complex map in the form of layer_id => { role_type => group_id }
    # We need that because TS only knows layers, but we move roles to groups inside the layer
    def group_ids = @@group_ids ||= layer_groups_role_map.map do |key, values|
      [key, values.merge(layer_child_groups_role_map[key].to_h)]
    end.to_h

    def layer_child_groups_role_map = @@layer_child_groups_role_map ||= Group.joins(:parent)
      .where.not("groups.id = groups.layer_group_id")
      .pluck("parents_groups.ts_code, groups.type, groups.id")
      .then { |scope| build_role_group_id_map(scope) }

    def layer_groups_role_map = @@layer_groups_role_map ||= Group
      .where("id = layer_group_id").pluck("ts_code, type, id")
      .then { |scope| build_role_group_id_map(scope) }

    # expects arrays in the form of [ts_code, type, id]
    def build_role_group_id_map(relation) = relation
      .group_by(&:shift)
      .transform_values { |list|
        list.flat_map { |type, id| type.constantize.role_types.map(&:to_s).product([id]) }.to_h
      }

    def people = @@people ||= ::Person.pluck(:id, :first_name, :last_name)
      .map { |id, first_name, last_name| [id, "#{first_name} #{last_name} (#{id})"] }
      .to_h
  end
end
