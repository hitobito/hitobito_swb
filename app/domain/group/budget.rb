# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Group::Budget
  PATTERN = /^(?<lower>\d+)?\.\.(?<upper>\d+)?$/

  attr_reader :value, :upper, :lower

  def self.list = Settings.groups.yearly_budgets.map { |val| new(val) }

  def initialize(value)
    @value = value
    @lower, @upper = PATTERN.match(value)&.captures
    raise ArgumentError, "invalid #{self.class.name}: #{value}" unless valid?
  end

  def to_s = value

  def to_fs
    text = if [lower, upper].all?(&:present?)
      "#{lower} - #{upper}"
    elsif upper.present?
      I18n.t("global.below", value: upper)
    elsif lower.present?
      I18n.t("global.above", value: lower)
    end

    "#{text} #{Settings.currency.unit}"
  end

  private

  def valid? = [@lower, @upper].any?(&:present?)
end
