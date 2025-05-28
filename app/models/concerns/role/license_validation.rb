# frozen_string_literal: true

#  Copyright (c) 2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Role::LicenseValidation
  extend ActiveSupport::Concern

  included do
    before_validation :set_license_end_on, unless: :end_on?

    validate :end_on_read_only
  end

  private

  def set_license_end_on
    today = Time.zone.today
    end_on_year = ((today < Time.zone.local(today.year, 6, 14)) ? today : today.next_year).year
    self.end_on = Date.new(end_on_year, 6, 14)
  end

  def end_on_read_only
    return if new_record? || end_on.blank?

    if will_save_change_to_end_on?
      errors.add(:end_on, :readonly)
    end
  end
end
