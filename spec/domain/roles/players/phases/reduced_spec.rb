# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Roles::Players::Phases::Reduced do
  let(:person) { people(:member) }
  let(:group) { groups(:brb_spieler) }
  let!(:player_role) { Fabricate(Group::RegionSpieler::Lizenz.sti_name, group:, person:) }
  let(:role) { player_role }

  subject(:check) { described_class.new(role) }

  it "allows create" do
    expect(check.create?).to be_truthy
  end

  it "allows update" do
    expect(check.update?).to be_truthy
  end

  it "does not allow destroy" do
    expect(check.destroy?).to be_falsey
  end

  it "allows create of same type" do
    expect(described_class.new(Group::RegionSpieler::Lizenz.new(person:, group:)).create?).to be_truthy
  end

  describe "first player role in group" do
    let!(:player_role) { nil }
    let(:role) { Group::RegionSpieler::Lizenz.new(person:, group:) }

    it "allows create" do
      expect(check.create?).to be_truthy
    end
  end

  describe "downgrade" do
    let(:role) { Group::RegionSpieler::JuniorU15.new(person:, group:) }

    it "does not allow create" do
      expect(check.create?).to be_falsey
    end
  end

  context "junior" do
    let(:person) { people(:member).tap { |p| p.update_columns(birthday: 16.years.ago.to_date) } }

    describe "upgrade from membership to licence" do
      let!(:player_role) { Fabricate(Group::RegionSpieler::AktivmitgliedU19.sti_name, group:, person:) }
      let(:role) { Group::RegionSpieler::JuniorU19.new(person:, group:) }

      it "allows create" do
        expect(check.create?).to be_truthy
      end
    end

    describe "downgrade from licence to membership" do
      let!(:player_role) { Fabricate(Group::RegionSpieler::JuniorU19.sti_name, group:, person:) }
      let(:role) { Group::RegionSpieler::AktivmitgliedU19.new(person:, group:) }

      it "does not allow create" do
        expect(check.create?).to be_falsey
      end
    end
  end
end
