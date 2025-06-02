# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Roles::Players::Phases::Open do
  let(:person) { people(:member) }
  let(:group) { groups(:brb_spieler) }
  let!(:player_role) { Fabricate(Group::RegionSpieler::Lizenz.sti_name, group:, person:) }
  let(:role) { player_role }

  subject(:check) { described_class.new(role) }

  it "allows create" do
    expect(check.create?).to be_truthy
  end

  it "allows update when upgrading a role" do
    expect(check.update?).to be_truthy
  end

  it "allows destroy" do
    expect(check.destroy?).to be_truthy
  end

  context "downgrade" do
    let(:role) { Group::RegionSpieler::JuniorU15.new(person:, group:) }

    it "allows create" do
      expect(check.create?).to be_truthy
    end

    it "allows update" do
      expect(check.update?).to be_truthy
    end
  end
end
