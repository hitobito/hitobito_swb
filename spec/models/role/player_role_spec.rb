# frozen_string_literal: true

#  Copyright (c) 2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Role::PlayerRole do
  let(:group) { groups(:brb_spieler) }
  let(:person) { people(:admin) }

  class Group::RegionSpieler::U6Player < ::Role::PlayerRole # rubocop:disable Lint/ConstantDefinitionInBlock
  end

  before do
    Group::RegionSpieler.roles << Group::RegionSpieler::U6Player << Group::RegionSpieler::NonPlayerRole
  end

  subject(:role) { Group::RegionSpieler::U6Player.build(group:, person:) }

  it "is invalid when player role already exists in group" do
    Fabricate(Group::RegionSpieler::Lizenz.sti_name, group:, person:)
    expect(role).not_to be_valid
    expect(role.errors.full_messages).to eq ["Person hat bereits eine Spielerrolle in dieser Gruppe"]
  end

  it "is valid if player role exists in different group" do
    Fabricate(Group::RegionSpieler::Lizenz.sti_name, group: groups(:bvn_spieler), person:)
    expect(role).to be_valid
  end
end
