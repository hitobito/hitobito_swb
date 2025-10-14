# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Role do
  describe "ts_model" do
    let(:group) { groups(:brb) }
    let(:person) { people(:admin) }
    let(:ts_code) { Faker::Internet.uuid }
    let(:created_at) { Time.zone.local(2025, 4, 9, 10, 12) }

    subject(:role) {
      Fabricate.build(Group::Region::Interclub.sti_name, group:, person:, ts_code:, id: 123,
        created_at:, start_on: nil)
    }

    subject(:ts_model) { role.ts_model }

    it "maps standard attributes" do
      expect(ts_model).to have_attributes(
        code: ts_code,
        organization_group_code: "89c11ebb-5266-4c0a-8d2a-1cc3a05ff06a",
        organization_role_code: "d1e0e7eb-293f-455f-93d0-f5c02615a42f"
      )
    end

    describe "dates" do
      it "uses created_at for start_date" do
        expect(ts_model.start_date).to eq "2025-04-09T10:12:00+02:00"
      end

      it "uses start_on for start_date if set" do
        role.start_on = Date.new(2025, 4, 10)
        expect(ts_model.start_date).to eq "2025-04-10T00:00:00+02:00"
      end

      it "uses default_value for end_date" do
        expect(ts_model.end_date).to eq "9999-12-31T23:59:59+01:00"
      end

      it "uses end_on for end_date if set" do
        role.end_on = Date.new(2025, 5, 10)
        expect(ts_model.end_date).to eq "2025-05-10T00:00:00+02:00"
      end
    end

    describe "ts_destroy_values" do
      it "returns values required for ending role on ts" do
        expect(role.ts_destroy_values).to include(
          group_id: role.group_id,
          person_id: role.person_id,
          ts_code: role.ts_code,
          end_on: Time.zone.yesterday,
          type: role.type
        )
      end
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

    describe Group::Region::Interclub do
      subject(:model_name) { described_class.model_name }

      let(:group) { groups(:brb) }
      let(:ts_code) { Faker::Internet.uuid }

      it "has ts_role" do
        expect(model_name.ts_role.name).to eq "Region Interclub"
        expect(model_name.ts_role.code).to eq "d1e0e7eb-293f-455f-93d0-f5c02615a42f"
      end

      it "has no ts_membership" do
        expect(model_name.ts_membership).to be_nil
      end

      it "has ts suffix in model name" do
        expect(model_name.human).to eq "Verantwortliche:r Interclub (TS)"
      end

      it "has ts suffix in model instance #to_s" do
        # rubocop:todo Layout/LineLength
        expect(Fabricate.build(described_class.sti_name).to_s).to eq "Verantwortliche:r Interclub (TS - wartet)"
        # rubocop:enable Layout/LineLength
      end

      it "has ts suffix in model instance #to_s" do
        role = Fabricate(described_class.sti_name, group:, ts_code:)
        HitobitoLogEntry.create!(
          category: :ts,
          level: :info,
          subject: role,
          message: "Synced",
          created_at: Time.zone.local(2025, 4, 4, 9, 42)
        )
        expect(role.ts_latest_log).to be_present
        expect(role.ts_log).to be_present
        expect(role.to_s).to eq "Verantwortliche:r Interclub (TS - erfolgreich - 04.04 09:42)"
      end

      it "has ts failed suffix in model instance #to_s" do
        role = Fabricate(described_class.sti_name, group:, ts_code:)
        HitobitoLogEntry.create!(
          category: :ts,
          level: :error,
          subject: role,
          message: "Synced",
          created_at: Time.zone.local(2025, 4, 4, 9, 42)
        )
        expect(role.ts_latest_log).to be_present
        expect(role.ts_log).to be_present
        expect(role.to_s).to eq "Verantwortliche:r Interclub (TS - fehlgeschlagen - 04.04 09:42)"
      end
    end

    describe Group::VereinSpieler::Lizenz do
      subject(:model) {
        Fabricate.build(described_class.sti_name, group: groups(:bc_bern_spieler),
          created_at: Time.zone.now)
      }

      it "uses membership code and maps group from layer" do
        expect(model.ts_model).to have_attributes(
          organization_group_code: groups(:bc_bern).ts_code,
          organization_membership_code: "abcd4c8a-eafe-44d3-a009-8afbc8f34500"
        )
      end

      describe "model_name" do
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

  describe "#to_s" do
    let(:group) { groups(:brb) }
    let(:person) { people(:admin) }
    let(:ts_code) { Faker::Internet.uuid }
    let(:role) { Fabricate(Group::Region::JSCoach.sti_name, person:, group:) }

    it "uses translation" do
      expect(role.to_s).to eq "J+S Coach"
    end

    context "ts managed role" do
      let(:role) { Fabricate(Group::Region::Interclub.sti_name, person:, group:) }

      it "has pending ts suffix with ts_code or log_entry" do
        expect(role.to_s).to eq "Verantwortliche:r Interclub (TS - wartet)"
      end

      it "has pending suffix if role has neither ts_code nor log_entry" do
        expect(role.to_s).to eq "Verantwortliche:r Interclub (TS - wartet)"
      end

      it "has ok suffix if role has ts_code but no log_entry yet" do
        role.ts_code = ts_code
        expect(role.to_s).to eq "Verantwortliche:r Interclub (TS - OK)"
      end

      it "has ok suffix with timestamp if sync succeeded" do
        travel_to Time.zone.local(2025, 9, 16, 12, 35) do
          Fabricate(:ts_log, subject: role)
        end
        expect(role.to_s).to eq "Verantwortliche:r Interclub (TS - erfolgreich - 16.09 12:35)"
      end

      it "has failed suffix with timestamp if sync failed" do
        travel_to Time.zone.local(2025, 9, 16, 12, 35) do
          Fabricate(:ts_log, subject: role, level: :error)
        end
        expect(role.to_s).to eq "Verantwortliche:r Interclub (TS - fehlgeschlagen - 16.09 12:35)"
      end
    end
  end
end
