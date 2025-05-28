module Roles::Players
  class Checker
    UPGRADES = {
      "Aktivmitglied" => ["Lizenz", "LizenzPlusJunior", "LizenzPlus", "LizenzNoRanking", "Vereinigungsspieler"],
      "Passivmitglied" => ["Aktivmitglied", "Lizenz", "JuniorU15", "JuniorU19", "LizenzPlusJunior", "LizenzPlus", "LizenzNoRanking", "Vereinigungsspieler"],
      "JuniorU15" => ["Aktivmitglied", "Lizenz", "JuniorU19", "LizenzPlusJunior", "LizenzPlus", "LizenzNoRanking", "Vereinigungsspieler"],
      "JuniorU19" => ["Aktivmitglied", "Lizenz", "LizenzPlusJunior", "LizenzPlus", "LizenzNoRanking", "Vereinigungsspieler"],
      "Lizenz" => ["Vereinigungsspieler"],
      "LizenzPlusJunior" => ["Vereinigungsspieler"],
      "LizenzPlus" => ["Vereinigungsspieler"],
      "LizenzNoRanking" => ["Vereinigungsspieler"],
      "Vereinigungsspieler" => []
    }.freeze

    attr_reader :role, :type, :current_type

    delegate :group, to: :role

    def initialize(role)
      @role = role
      @type = demodulize(role)
      @current_type = demodulize(role.person.roles.find_by(group:)) if role.person
    end

    def junior_role?
      ["JuniorU15", "JuniorU19"].include?(type)
    end

    def upgrade?
      same_type? ? true : UPGRADES[current_type].to_a.include?(type)
    end

    def has_role?
      @current_type.present?
    end

    def new_role?
      @role.new_record?
    end

    private

    def same_type? = type == current_type

    def demodulize(role) = (role.type.demodulize if role)
  end
end
