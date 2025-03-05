# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe TsModel do
  let(:ts_code) { Faker::Internet.uuid }

  shared_examples "ts model" do |entity_class:|
    it "has #{entity_class} as ts_entity" do
      expect(model.ts_entity).to eq(entity_class)
    end

    it "builds ts_model with values from ts_params" do
      expect(model.ts_model).to be_kind_of(entity_class)

      ts_params.each do |key, value|
        expect(model.ts_model.send(key)).to eq value
      end
    end

    describe "delegates operations to interface" do
      let(:client) { instance_double(Ts::Client) }
      let(:nesting) { nil }
      let(:hitobito_logs) { HitobitoLogEntry.where(category: :ts, subject: model, level: :info) }

      it "delegates get" do
        expect(model.send(:ts_interface)).to receive(:get)
        model.ts_interface_get
      end

      it "delegates post" do
        expect(model.send(:ts_interface)).to receive(:post)
        model.ts_interface_post
      end

      it "delegates put" do
        expect(model.send(:ts_interface)).to receive(:put)
        model.ts_interface_put
      end
    end
  end

  describe Group do
    let(:parent) { groups(:root) }

    subject(:model) { Fabricate.build(Group::Region.sti_name, id: 1, ts_code:, parent:) }

    it_behaves_like "ts model", entity_class: Ts::Entity::OrganizationGroup do
      let(:model_changes) { {name: "new name"} }
      let(:ts_params) { {name: model.name, code: ts_code, parent_code: model.parent_ts_code} }
    end
  end

  describe Person do
    subject(:model) { Fabricate.build(:person, id: 1, ts_code:) }

    it_behaves_like "ts model", entity_class: Ts::Entity::OrganizationPerson do
      let(:model_changes) { {town: "new name"} }
      let(:ts_params) { {code: ts_code, firstname: model.first_name, lastname: model.last_name, email: model.email, member_id: 1} }
    end
  end

  describe Role do
    let(:group) { groups(:root_vorstand) }
    let(:person) { people(:admin) }
    let(:now) { Time.zone.local(2025, 4, 1, 16, 10) }
    let(:nesting) { person.ts_model }

    subject(:model) { Fabricate.build(Group::DachverbandVorstand::Praesident.sti_name, group:, person:, ts_code:, id: 1) }

    before { travel_to(now) }

    it_behaves_like "ts model", entity_class: Ts::Entity::OrganizationMembership do
      let(:model_changes) { {start_on: 2.days.ago.to_date} }
      let(:ts_params) {
        {
          code: ts_code,
          start_date: "2025-04-01T16:10:00+02:00",
          end_date: "2125-04-01T16:10:00+02:00",
          organization_group_code: group.parent_ts_code,
          organization_role_code: "4c0a8178-035a-415b-933b-468a4a4cedae"
        }
      }
    end
  end
end
