# frozen_string_literal: true

#  Copyright (c) 2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Role::Player do
  let(:group) { groups(:brb_spieler) }
  let(:person) { people(:admin) }

  subject(:role) { Group::RegionSpieler::Aktivmitglied.build(group:, person:) }

  describe "::validations" do
    describe "asserting single player role" do
      it "is invalid if person has any other role in that group" do
        Fabricate(Group::RegionSpieler::Lizenz.sti_name, group:, person:)
        expect(role).not_to be_valid
        expect(role.errors.full_messages).to eq ["Person hat bereits eine Spielerrolle in dieser Gruppe"]
      end

      it "is valid if player role exists in a different group" do
        Fabricate(Group::RegionSpieler::Lizenz.sti_name, group: groups(:bvn_spieler), person:)
        expect(role).to be_valid
      end

      it "can still update that single player role" do
        role.save!
        expect(role.update!(end_on: 3.days.from_now)).to eq true
      end
    end
  end

  it "all spieler group roles are players" do
    all_types = [Group::DachverbandSpieler, Group::RegionSpieler, Group::VereinSpieler].flat_map(&:role_types)
    all_types.each do |type|
      expect(type.new).to be_kind_of(Role::Player)
    end
  end
end
