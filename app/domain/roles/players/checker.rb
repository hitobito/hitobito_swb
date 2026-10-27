# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Roles::Players
  class Checker
    attr_reader :role, :type, :current_type, :upgrades

    JUNIOR_TYPES = [
      "JuniorU15",
      "JuniorU19",
      "AktivmitgliedU15",
      "AktivmitgliedU19"
    ]

    delegate :group, to: :role

    def initialize(role)
      @role = role
      @type = demodulize(role)
      @current_type = demodulize(role.person.roles.find_by(group:)) if role.person
      @upgrades = Settings.roles.phases.upgrades.to_h.stringify_keys
    end

    def junior? = JUNIOR_TYPES.include?(type)

    def new? = role.new_record?

    def first_role? = new? && current_type.blank?

    def same_type? = type == current_type

    def upgrade? = upgrades.fetch(current_type, []).include?(type)

    private

    def demodulize(role) = role&.type&.demodulize
  end
end
