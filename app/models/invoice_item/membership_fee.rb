# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class InvoiceItem::MembershipFee < InvoiceItem
  # NOTE: Needed to persist model, should be translated, not sure where this is done in SBV
  attribute :name, :string, default: "MembershipFee"
  attribute :unit_cost, :integer, default: 10

  self.dynamic = true

  AMOUNT = 10

  ROLE_TYPES = %w[
    Group::VereinSpieler::Aktivmitglied
    Group::VereinSpieler::Passivmitglied
    Group::VereinSpieler::JuniorU15
    Group::VereinSpieler::JuniorU19
    Group::VereinSpieler::Lizenz
    Group::VereinSpieler::LizenzPlusJunior
    Group::VereinSpieler::LizenzPlus
    Group::VereinSpieler::LizenzNoRanking
    Group::VereinSpieler::Vereinigungsspieler
  ]

  def recalculate
    self.count = roles_count.values.sum
    self[:cost] = (unit_cost && count) ? unit_cost * count : 0 unless destroyed?
  end

  def dynamic_cost = fail "Try to avoid"

  def roles_count(layer_group_id: nil, role_types: ROLE_TYPES)
    @roles_count ||= Role.where(type: role_types)
      .joins(:group)
      .then { |scope| layer_group_id ? scope.where(groups: {layer_group_id:}) : scope }
      .group("groups.layer_group_id")
      .count
  end
end
