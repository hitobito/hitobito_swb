# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class InvoiceItem::MembershipFee < InvoiceItem
  # NOTE: Needed to persist model, should be translated, not sure where this is done in SBV
  attribute :name, :string, default: "MembershipFee"
  attribute :unit_cost, :decimal, default: -> { BigDecimal(10) }

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

  # TODO: maybe this does get called somewhere else as well
  def calculate_amount(recipient: nil)
    layer_group_id = recipient.roles.find_by(type: Group::Verein::Finanzen.sti_name).group.layer_group_id if recipient
    self.count = roles_count(layer_group_id:).count.values.sum
  end

  # TODO maybe cache but do that later
  def roles_count(layer_group_id: nil, role_types: ROLE_TYPES)
    Role.where(type: role_types)
      .joins(:group)
      .then { |scope| layer_group_id ? scope.where(groups: {layer_group_id:}) : scope }
      .group("groups.layer_group_id")
  end
end
