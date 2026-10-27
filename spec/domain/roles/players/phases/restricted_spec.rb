# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Roles::Players::Phases::Restricted do
  let(:person) { people(:member) }
  let(:group) { groups(:brb_spieler) }
  let!(:player_role) { Fabricate(Group::RegionSpieler::Lizenz.sti_name, group:, person:) }
  let(:role) { player_role }

  subject(:check) { described_class.new(role) }

  it "does not allow create for lizenz role" do
    expect(check.create?).to be_falsey
  end

  it "does not allow update" do
    expect(check.update?).to be_falsey
  end

  it "does not allow destroy" do
    expect(check.destroy?).to be_falsey
  end

  context "junior" do
    let(:person) { people(:member).tap { |p| p.update_columns(birthday: 16.years.ago.to_date) } }

    describe "first player role in group" do
      let!(:player_role) { nil }
      let(:role) { Group::RegionSpieler::JuniorU19.new(person:, group:) }

      it "allows create" do
        expect(check.create?).to be_truthy
      end
    end

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

    describe "update of membership" do
      let!(:player_role) { Fabricate(Group::RegionSpieler::AktivmitgliedU19.sti_name, group:, person:) }

      it "allows opening the edit form" do
        expect(check.update?).to be_truthy
      end

      it "allows create of same type" do
        candidate = Group::RegionSpieler::AktivmitgliedU19.new(person:, group:)
        expect(described_class.new(candidate).create?).to be_truthy
      end
    end

    describe "update of licence" do
      let!(:player_role) { Fabricate(Group::RegionSpieler::JuniorU19.sti_name, group:, person:) }

      it "does not allow opening the edit form" do
        expect(check.update?).to be_falsey
      end
    end
  end
end
