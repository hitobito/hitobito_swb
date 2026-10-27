# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Roles::Players::Checker do
  let(:group) { groups(:bc_bern_spieler) }
  let(:person) { people(:member) }

  def check(role, attrs = {group_id: group.id, person_id: person.id})
    described_class.new(Group::VereinSpieler.const_get(role).new(attrs))
  end

  it "#junior? knows about what roles are junior" do
    expect(check("JuniorU15")).to be_junior
    expect(check("JuniorU19")).to be_junior
    expect(check("AktivmitgliedU15")).to be_junior
    expect(check("AktivmitgliedU19")).to be_junior
    expect(check("LizenzPlusJunior")).not_to be_junior
    expect(check("Aktivmitglied")).not_to be_junior
    expect(check("Lizenz")).not_to be_junior
  end

  describe "#upgrade?" do
    let!(:existing_role) {
      Fabricate(Group::VereinSpieler::Aktivmitglied.sti_name, person:, group:)
    }
    let(:attrs) { {person_id: person.id, group_id: group.id} }

    it "is false for same type" do
      expect(check("Aktivmitglied", attrs)).not_to be_upgrade
      expect(check("Aktivmitglied", attrs)).to be_same_type
    end

    it "is true for Lizenz" do
      expect(check("Lizenz", attrs)).to be_upgrade
    end

    it "is false for Passivmitglied" do
      expect(check("Passivmitglied", attrs)).not_to be_upgrade
    end
  end

  context "junior" do
    let(:person) { people(:member).tap { |p| p.update_columns(birthday: 16.years.ago.to_date) } }

    def existing(type) = Fabricate(Group::VereinSpieler.const_get(type).sti_name, person:, group:)

    describe "#upgrade?" do
      it "is true from membership to licence up to U15" do
        person.update_columns(birthday: 12.years.ago.to_date)
        existing("AktivmitgliedU15")
        expect(check("JuniorU15")).to be_upgrade
      end

      it "is true from membership to licence U17-U19" do
        existing("AktivmitgliedU19")
        expect(check("JuniorU19")).to be_upgrade
      end
    end

    describe "#upgradeable?" do
      it "is true for membership" do
        expect(described_class.new(existing("AktivmitgliedU19"))).to be_upgradeable
      end

      it "is false for licence" do
        expect(described_class.new(existing("JuniorU19"))).not_to be_upgradeable
      end
    end
  end

  describe "#new?" do
    it "is true for new role" do
      expect(check("JuniorU15")).to be_new
    end

    it "is false for existing role" do
      role = Fabricate(Group::VereinSpieler::Lizenz.sti_name, person:,
        group: groups(:bc_thun_spieler))
      expect(described_class.new(role)).not_to be_new
    end
  end

  describe "#first_role?" do
    it "is true for new role" do
      expect(check("JuniorU15")).to be_first_role
    end

    it "is true for new role if another exists for another group" do
      Fabricate(Group::VereinSpieler::Lizenz.sti_name, person:, group: groups(:bc_thun_spieler))
      expect(check("JuniorU15")).to be_first_role
    end

    it "is false for new role if another exists for that group" do
      Fabricate(Group::VereinSpieler::Lizenz.sti_name, person:, group: group)
      expect(check("JuniorU15")).not_to be_first_role
    end
  end
end
