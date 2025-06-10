# frozen_string_literal: true

#  Copyright (c) 2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Role::Player < ::Role
  class_attribute :year_range, default: (19..)

  validate :only_one_player_role_per_group
  validate :within_year_range

  self.permissions = [:group_read]

  private

  def person_years
    person.years(Time.zone.now.next_year.beginning_of_year)
  end

  def only_one_player_role_per_group
    errors.add(:person, :already_player_in_group) if (person.roles.where(group:) - [self]).any?
  end

  def within_year_range
    min_date = Date.new(Time.zone.now.year - year_range.end) if year_range.end
    max_date = Date.new(Time.zone.now.year - year_range.begin).end_of_year if year_range.begin

    if min_date && person.birthday < min_date
      errors.add(:person, :must_be_born_after, date: I18n.l(min_date))
    elsif max_date && person.birthday > max_date
      errors.add(:person, :must_be_born_before, date: I18n.l(max_date))
    end
  end

  class JuniorU15 < Player
    self.year_range = (..14)
  end

  class JuniorU19 < Player
    self.year_range = (15..18)
  end
end
