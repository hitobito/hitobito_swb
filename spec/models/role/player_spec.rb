# frozen_string_literal: true

#  Copyright (c) 2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Role::Player do
  let(:person) { people(:admin) }

  describe "::validations" do
    describe "asserting single player role" do
      let(:group) { groups(:brb_spieler) }

      subject(:role) { Group::RegionSpieler::Aktivmitglied.build(group:, person:) }

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

      it "can still destroy old role even if multiple exist" do
        Fabricate(Group::RegionSpieler::Aktivmitglied.sti_name, group:, person:)
        role = Fabricate.build(
          Group::RegionSpieler::Aktivmitglied.sti_name,
          group:, person:,
          created_at: 1.month.ago,
          updated_at: 1.month.ago
        )
        role.save!(validate: false)
        expect(role.destroy).to be_truthy
      end
    end

    describe "asserting license role" do
      let(:group) { groups(:bc_bern_spieler) }

      subject(:role) { Group::VereinSpieler::Lizenz.build(group:, person:) }

      it "is invalid if person has any other role in that group" do
        Fabricate(Group::VereinSpieler::Aktivmitglied.sti_name, group:, person:)
        expect(role).not_to be_valid
        expect(role.errors.full_messages).to eq ["Person hat bereits eine Spielerrolle in dieser Gruppe"]
      end

      it "is invalid if role of that type exists in a different group" do
        Fabricate(Group::VereinSpieler::Lizenz.sti_name, group: groups(:bc_thun_spieler), person:)
        expect(role).not_to be_valid
        expect(role.errors.full_messages).to eq ["Person hat bereits eine Spielerrolle dieses Typs"]
      end

      it "is valid if player has no other player roles" do
        expect(role).to be_valid
      end

      it "is valid if player has another lizenz role type in a different layer" do
        Fabricate(Group::VereinSpieler::LizenzPlus.sti_name, group: groups(:bc_thun_spieler),
          person:)
        expect(role).to be_valid
      end

      it "can still update that single player role" do
        role.save!
        expect(role.update!(end_on: 3.days.from_now)).to eq true
      end
    end
  end

  shared_examples "year_validating_role" do |role_class, year_range|
    min_date = year_range.end.years.ago.to_date.beginning_of_year if year_range.end
    max_date = year_range.begin.years.ago.to_date.end_of_year if year_range.begin

    let(:group) { role_class.to_s.deconstantize.constantize.first }
    let!(:role) { Fabricate(role_class.sti_name, group: group, person: person) }
    let(:person) { Fabricate(:person, birthday: min_date.presence || max_date.presence) }

    describe role_class do
      if min_date
        it "is valid with person born on #{min_date}" do
          person.birthday = min_date
          expect(role).to be_valid
        end

        it "is too old with person born on #{min_date - 1.day}" do
          expect(role).to be_valid
          person.update_columns(birthday: min_date - 1.day)
          expect(role).not_to be_valid
          expect(role.errors.full_messages).to eq ["Person muss an oder nach dem #{I18n.l(min_date)} geboren sein"]
        end

        it "still allows destroying person born on #{min_date - 1.day}" do
          expect(role).to be_valid
          person.update_columns(birthday: min_date - 1.day)
          expect { role.destroy! }.to change { Role.count }.by(-1)
        end
      else
        it "is valid with person born on #{max_date - 100.years}" do
          person.update_columns(birthday: max_date - 100.years)
          expect(role).to be_valid
        end
      end

      if max_date
        it "is valid with person born on #{max_date}" do
          person.birthday = max_date
          expect(role).to be_valid
        end

        it "is too young with person born on #{max_date + 1.day}" do
          person.birthday = max_date + 1.day
          expect(role).not_to be_valid
          expect(role.errors.full_messages).to eq ["Person muss an oder vor dem #{I18n.l(max_date)} geboren sein"]
        end

        it "still allows destroying person born on #{max_date - 1.day}" do
          person.birthday = max_date + 1.day
          role.created_at = 1.day.ago # rqeuired for
          expect { role.destroy! }.to change { Role.count }.by(-1)
        end
      else
        it "is valid with person born on #{min_date + 5.years}" do
          person.birthday = min_date + 5.years
          expect(role).to be_valid
        end
      end
    end
  end

  describe "year validations" do
    it_behaves_like "year_validating_role", Group::VereinSpieler::JuniorU15, (..14)
    it_behaves_like "year_validating_role", Group::VereinSpieler::JuniorU19, (15..18)
    it_behaves_like "year_validating_role", Group::VereinSpieler::Lizenz, (19..)
    it_behaves_like "year_validating_role", Group::VereinSpieler::LizenzPlusJunior, (..18)
    it_behaves_like "year_validating_role", Group::VereinSpieler::Aktivmitglied, (19..)
    it_behaves_like "year_validating_role", Group::VereinSpieler::Passivmitglied, (19..)
    it_behaves_like "year_validating_role", Group::VereinSpieler::Vereinigungsspieler, (0..)

    Role::Player.subclasses.each do |subclass|
      case subclass.to_s
      when /U15/
        it "has U15 ..14 year range" do
          expect(subclass.year_range).to eq(..14)
        end
      when /U19/
        it "has U19 15..19 year range" do
          expect(subclass.year_range).to eq 15..18
        end
      when /LizenzPlusJunior/
        it "has U19 15..19 year range" do
          expect(subclass.year_range).to eq(..18)
        end
      when /Vereinigungsspieler/
        it "has open year range" do
          expect(subclass.year_range).to eq 0..
        end
      else
        it "has default 19.. year range" do
          expect(subclass.year_range).to eq 19..
        end
      end
    end
  end

  [Group::DachverbandSpieler, Group::RegionSpieler,
    Group::VereinSpieler].flat_map(&:role_types).each do |type|
    describe type do
      it "is a Role::Player" do
        expect(type.new).to be_kind_of(Role::Player)
      end

      if /Lizenz/.match?(type.to_s)
        it "is unique across layers" do
          expect(type.unique_across_layers).to eq true
        end
      else
        it "is not unique across layers" do
          expect(type.unique_across_layers).to eq false
        end
      end
    end
  end

  describe "billed models" do
    let(:billing_period) { billing_periods(:current) }
    let(:group) { groups(:bc_bern_spieler) }

    it "updates billed model" do
      model = Fabricate(Group::VereinSpieler::Aktivmitglied.sti_name, person:, group:,
        end_on: 1.day.ago)
      Fabricate(:billed_model, billing_period:, model:)
      expect do
        role = Fabricate(Group::VereinSpieler::Lizenz.sti_name, person:, group:)
        expect(BilledModel.where(model: role, billing_period:)).to be_exists
      end.to change { BilledModel.count }.from(1).to(2)
    end
  end
end
