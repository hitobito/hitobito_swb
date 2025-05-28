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
      @current_type = demodulize(role.person.roles.find_by(group:))
    end

    def new_role
      role.new_record?
    end

    def junior_role?
      ["JuniorU15", "JuniorU19"].include?(role_type)
    end

    def upgrade?
      same_type? ? true : UPGRADES[current_type].include?(type)
    end

    private

    def same_type? = role_type == current_player_role&.type

    def demodulized_role_type(role) = role.type.demodulize if role
  end
end
