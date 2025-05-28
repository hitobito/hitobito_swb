# frozen_string_literal: true

#  Copyright (c) 2025, Hitobito AG. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Roles::Players::PhaseChecker do
  let(:person) { people(:member) }
  let(:group) { groups(:brb_spieler) }
  let!(:player_role) { Fabricate(Group::RegionSpieler::Lizenz.sti_name, group:, person:) }
  let(:check) { described_class.new(Group::RegionSpieler::Lizenz.new(person:, group:)) }

  # Anything can be done in phase_1
  context "phase 1" do
    around { |example| travel_to(Date.new(2025, 6, 15)) { example.run } }

    it "allows create" do
      player_role.destroy! # player should not have current_role
      expect(check.create?).to be_truthy
    end

    it "allows create when downgarding a role" do
      check = described_class.new(Group::RegionSpieler::JuniorU15.new(person:, group:)) # lizenz to junior role is a downgrade
      expect(check.create?).to be_truthy
    end

    it "allows update when upgrading a role" do
      expect(check.update?).to be_truthy
    end

    it "allows update when downgarding a role" do
      check = described_class.new(Group::RegionSpieler::JuniorU15.new(person:, group:)) # lizenz to junior role is a downgrade
      expect(check.update?).to be_truthy
    end

    it "allows destroy" do
      expect(check.destroy?).to be_truthy
    end
  end

  # During phase_2, it is still possible to create new roles.
  # Deleting old roles is not possible anymore, as well as downgrading roles.
  # All possible role upgrades are defined in Roles::Players::PhaseChecker::ROLE_UPGRADES
  context "phase 2" do
    around { |example| travel_to(Date.new(2025, 8, 16)) { example.run } }

    it "allows create" do
      player_role.destroy! # player should not have current_role
      expect(check.create?).to be_truthy
    end

    it "allows create when upgrading a role" do
      expect(check.create?).to be_truthy
    end

    it "does not allow create when downgrading a role" do
      check = described_class.new(Group::RegionSpieler::JuniorU15.new(person:, group:)) # lizenz to junior role is a downgrade
      expect(check.create?).to be_falsey
    end

    it "allows update when upgrading a role" do
      expect(check.update?).to be_truthy
    end

    it "does not allow update when downgarding a role" do
      check = described_class.new(Group::RegionSpieler::JuniorU15.new(person:, group:)) # lizenz to junior role is a downgrade
      expect(check.update?).to be_falsey
    end

    it "does not allow destroy" do
      expect(check.destroy?).to be_falsey
    end
  end

  # During phase_3, nothing besides the creation of certain roles is allowed, no upgrades/downgrades, no deletions
  # Only junior roles can be created
  context "phase 3" do
    around { |example| travel_to(Date.new(2025, 1, 1)) { example.run } }

    it "does not allow create for lizenz role" do
      player_role.destroy! # player should not have current_role
      expect(check.create?).to be_falsey
    end

    it "allows create for junior role" do
      player_role.destroy! # player should not have current_role
      check = described_class.new(Group::RegionSpieler::JuniorU15.new)
      expect(check.create?).to be_truthy
    end

    it "does not allow update" do
      expect(check.update?).to be_falsey
    end

    it "does not allow update when downgarding a role" do
      check = described_class.new(Group::RegionSpieler::JuniorU15.new(person:, group:)) # lizenz to junior role is a downgrade
      expect(check.update?).to be_falsey
    end

    it "does not allow destroy" do
      expect(check.destroy?).to be_falsey
    end
  end
end
