# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class BillingPeriod < ActiveRecord::Base
  validates_by_schema

  scope :list, -> { order(:created_at) }

  validate :assert_single_period_active, if: :active

  has_many :billed_models, dependent: :destroy

  def self.active = find_by(active: true)

  def to_s = name

  private

  def assert_single_period_active
    if self.class.active && self.class.active != self
      errors.add(:base, :single_active)
    end
  end
end
