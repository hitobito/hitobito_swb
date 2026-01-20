# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Invoice::TeamItem < Item
  self.dynamic = true

  self.dynamic_cost_parameter_definitions = {
    leagues: :array,
    unit_cost: :decimal
  }

  validates :group_id, :leagues, :period_start_on, presence: true
  validates :unit_cost, money: true

  def count
    @count ||= base_scope
      .active(period_start_on..period_end_on)
      .where(id: group_scope)
      .where(teams: {league: leagues})
      .count
  end

  def dynamic_cost = unit_cost * count

  private

  def base_scope
    Group::Verein
      .without_archived_or_deleted
      .joins(:teams)
  end

  def group_scope
    within_group.self_and_descendants.select(:id)
  end

  def within_group
    # If the recipient is a group, we only count subgroups of the recipient
    return recipient if recipient&.is_a?(Group)
    # Otherwise, we count subgroups of the invoice's sender group.
    Group.find(group_id)
  end

  def recipient
    invoice&.recipient
  end

  def group_id
    dynamic_cost_parameters[:group_id] || invoice&.group_id
  end

  def leagues
    dynamic_cost_parameters[:leagues] || []
  end

  def unit_cost
    BigDecimal(dynamic_cost_parameters[:unit_cost])
  rescue ArgumentError, TypeError
    errors.add(:unit_cost, :is_not_a_decimal_number)
    BigDecimal(0)
  end

  def period_start_on
    dynamic_cost_parameters[:period_start_on]
  end

  def period_end_on
    dynamic_cost_parameters[:period_end_on]
  end
end
