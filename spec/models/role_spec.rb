# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Role do
  describe "ts_model" do
    let(:group) { groups(:brb_vorstand) }
    let(:person) { people(:admin) }
    let(:ts_code) { Faker::Internet.uuid }

    subject(:role) { Fabricate.build(Group::RegionVorstand::Praesident.sti_name, group:, person:, ts_code:, id: 123) }

    subject(:ts_model) { role.ts_model }

    it "maps standard attributes" do
      expect(ts_model).to have_attributes(
        code: ts_code,
        organization_group_code: "873e858d-a75d-42fb-83ff-62f09605074e",
        organization_role_code: "60c707b5-4020-44f0-8219-0349cc941342"
      )
    end

    it "uses parent ts_code if ts_code on group is blank" do
      group.ts_code = nil
      expect(ts_model).to have_attributes(
        code: ts_code,
        organization_group_code: "89c11ebb-5266-4c0a-8d2a-1cc3a05ff06a",
        organization_role_code: "60c707b5-4020-44f0-8219-0349cc941342"
      )
    end

    describe Group::Dachverband::Administrator do
      subject(:model_name) { described_class.model_name }

      it "has no ts_role" do
        expect(model_name.ts_role).to be_nil
      end

      it "has no ts_membership" do
        expect(model_name.ts_membership).to be_nil
      end

      it "has no ts suffix in model name" do
        expect(model_name.human).to eq "Administrator:in"
      end

      it "has no ts suffix in model instance #to_s" do
        expect(Fabricate.build(described_class.sti_name).to_s).to eq "Administrator:in"
      end
    end

    describe Group::DachverbandMitglieder::JSCoach do
      subject(:model_name) { described_class.model_name }

      it "has ts_role" do
        expect(model_name.ts_role.name).to eq "Swiss Badminton J&S-Coach"
        expect(model_name.ts_role.code).to eq "48dfaccf-30fa-487e-83e6-1161083452f1"
      end

      it "has no ts_membership" do
        expect(model_name.ts_membership).to be_nil
      end

      it "has ts suffix in model name" do
        expect(model_name.human).to eq "J&S Coach (TS)"
      end

      it "has ts suffix in model instance #to_s" do
        expect(Fabricate.build(described_class.sti_name).to_s).to eq "J&S Coach (TS - wartet)"
      end

      it "has ts suffix in model instance #to_s" do
        role = Fabricate(described_class.sti_name, group: groups(:root_mitglieder), ts_code: Faker::Internet.uuid)
        HitobitoLogEntry.create!(
          category: :ts,
          level: :info,
          subject: role,
          message: "Synced",
          created_at: Time.zone.local(2025, 4, 4, 9, 42)
        )
        expect(role.ts_latest_log).to be_present
        expect(role.ts_log).to be_present
        expect(role.to_s).to eq "J&S Coach (TS - erfolgreich - 04.04 09:42)"
      end

      it "has ts failed suffix in model instance #to_s" do
        role = Fabricate(described_class.sti_name, group: groups(:root_mitglieder), ts_code: Faker::Internet.uuid)
        HitobitoLogEntry.create!(
          category: :ts,
          level: :error,
          subject: role,
          message: "Synced",
          created_at: Time.zone.local(2025, 4, 4, 9, 42)
        )
        expect(role.ts_latest_log).to be_present
        expect(role.ts_log).to be_present
        expect(role.to_s).to eq "J&S Coach (TS - fehlgeschlagen - 04.04 09:42)"
      end
    end

    describe Group::VereinMitglieder::Lizenz do
      subject(:model_name) { described_class.model_name }

      it "has ts_role" do
        expect(model_name.ts_role)
      end

      it "has ts_membership" do
        expect(model_name.ts_membership.name).to eq "Lizenz"
        expect(model_name.ts_membership.code).to eq "abcd4c8a-eafe-44d3-a009-8afbc8f34500"
      end
    end
  end
end
