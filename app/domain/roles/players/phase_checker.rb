# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Roles::Players::PhaseChecker
  ROLE_UPGRADES = {
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

  attr_reader :subject_role, :date

  def initialize(subject_role, date = Time.zone.today)
    @subject_role = subject_role
    @date = date
  end

  def create?
    case current_phase
    when :phase_1 then true
    when :phase_2 then current_player_role ? role_upgrade? : new_role?
    when :phase_3 then new_role? && junior_role?
    else false
    end
  end

  def update?
    case current_phase
    when :phase_1 then true
    when :phase_2 then role_upgrade?
    else false
    end
  end

  def destroy?
    case current_phase
    when :phase_1 then true
    else false
    end
  end

  private

  def current_phase
    @current_phase ||= calculate_phase
  end

  def calculate_phase
    return :phase_1 if date.between?(Date.new(date.year, 6, 15), Date.new(date.year, 8, 15))
    return :phase_2 if date.between?(Date.new(date.year, 8, 16), Date.new(date.year, 12, 31))
    :phase_3
  end

  def junior_role?
    ["JuniorU15", "JuniorU19", nil].include?(demodulized_role_type)
  end

  def new_role?
    subject_role.id.nil?
  end

  def role_upgrade?
    return true if same_role_type?
    ROLE_UPGRADES[demodulized_role_type(current_player_role)].include?(demodulized_role_type)
  end

  def same_role_type?
    current_player_role&.type == subject_role.type
  end

  def demodulized_role_type(role = subject_role)
    role.type&.demodulize
  end

  def current_player_role
    return unless subject_role.person

    @current_player_role ||= subject_role.person.roles.find_by(group: subject_role.group)
  end
end
