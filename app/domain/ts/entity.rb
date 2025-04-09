# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
#
class Ts::Entity < Data
  APP_SUCCESS_CODE = 0

  class << self
    def path_name = element_name.gsub("Organization", "")

    def element_name = name.demodulize

    def build(attrs = {}) = new(**members.product([nil]).to_h.merge(attrs))

    def from_xml(xml, clear_whitespace: false)
      values = Hash.from_xml(xml).dig(name.demodulize).transform_keys(&:underscore).symbolize_keys
        .transform_values { |v| v.to_s[/^\d+$/] ? v.to_i : v }
        .transform_values do |v|
          next v unless v.is_a?(String)
          v.strip.then { |v| clear_whitespace ? v.gsub(/\s+/, " ") : v }
        end

      build(**values.slice(*members).compact_blank)
    end
  end

  def to_s = "#{name.demodulize}: #{name} (#{code})"

  def to_xml(options = {}) = to_xml_hash.to_xml(xml_options)

  def to_xml_hash =
    to_h.compact_blank
      .transform_keys { |k| k.to_s.camelize }
      .transform_keys { |k| k.ends_with?("Id") ? k.gsub("Id", "ID") : k }
      .transform_values { |v| v.is_a?(Ts::Entity) ? v.to_xml_hash : v }

  def xml_options = {root: self.class.element_name, skip_types: true, skip_instruct: true}

  Error = Ts::Entity.define(:code, :message) do
    def success? = code == APP_SUCCESS_CODE
  end

  Organization = Ts::Entity.define(:code, :name, :root_group_code)

  OrganizationLevel = Ts::Entity.define(:code, :name, :level)

  OrganizationGroup = Ts::Entity.define(:code, :parent_code, :number, :name,
    :contact, :email, :website, :address, :postal_code, :city, :country,
    :organization_level, :parent_organization_group)

  OrganizationRole = Ts::Entity.define(:code, :name, :organization_level_code)

  OrganizationPerson = Ts::Entity.define(:code, :member_id, :id_number, :name_type_id,
    :firstname, :middlename, :lastname, :gender_id, :date_of_birth, :nationality,
    :address, :address2, :address3, :postal_code, :city, :country,
    :phone, :mobile, :email, :website, :photo, :active)

  # This is used twice
  OrganizationMembership = Ts::Entity.define(:code, :name, :start_date, :end_date, :remote_system_code,
    :organization_group_code, :organization_group_name,
    :organization_role_code, :organization_role_name,
    :organization_membership_code, :organization_membership_name)

  module List
    def to_xml(list) = list.map(&:to_xml_hash).to_xml(root: list.first.class.name.demodulize.pluralize, skip_types: true)
      .gsub(list.first.class.name.demodulize.pluralize, "Result")

    def from_xml(text, stylesheet = nil)
      doc = Nokogiri::XML(text)
      doc = Nokogiri::XML(Nokogiri::XSLT(stylesheet).apply_to(doc)) if stylesheet
      doc.root.elements.map do |element|
        Ts::Entity.const_get(element.name.singularize).from_xml(element.to_s)
      end
    end
    module_function :to_xml, :from_xml
  end
end
