# frozen_string_literal: true

#  Copyright (c) 2025, Swiss Badminton. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas

require "spec_helper"

describe RoleAbility do
  let(:person) { people(:member) }
  let(:group) { groups(:brb_spieler) }
  let(:player_role) { Fabricate(Group::RegionSpieler::Lizenz.sti_name, group:, person:) }

  subject(:ability) { Ability.new(people(:admin)) }

  let(:phase) { instance_double(Roles::Players::Phases::Base) }

  before do
    expect(Roles::Players::Phases).to receive(:active).with(kind_of(Role)).and_return(phase)
  end

  it "calls phase_checker during create" do
    expect(phase).to receive(:create?).once.and_return(true)
    expect(ability).to be_able_to(:create, Group::RegionSpieler::JuniorU15.new(person:, group:))
  end

  it "calls phase_checker during update" do
    expect(phase).to receive(:update?).once.and_return(true)
    expect(ability).to be_able_to(:update, player_role)
  end

  it "calls phase_checker during destroy" do
    expect(phase).to receive(:destroy?).once.and_return(true)
    expect(ability).to be_able_to(:destroy, player_role)
  end
end
