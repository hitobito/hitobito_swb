# frozen_string_literal: true

#  Copyright (c) 2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Role::LizenzPlus < Role::Player
  before_validation :set_end_on, if: :new_record?

  validate :assert_end_on_unchanged, unless: :new_record?

  private

  def assert_end_on_unchanged
    if !Current.admin && will_save_change_to_end_on?
      errors.add(:end_on, :readonly)
    end
  end

  def set_end_on
    self.end_on = fixed_end_date
  end

  def fixed_end_date
    date = Time.zone.parse(Settings.roles.lizenz.end_date)
    date.future? ? date : date + 1.year
  end
end
