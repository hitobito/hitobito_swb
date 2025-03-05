# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Ts::Client, :tests_ts_api do
  subject(:client) { described_class.new(entity.class) }

  context "Group" do
    let(:sub_path) { "/Group/#{code}" }
    let(:parent_code) { Faker::Internet.uuid }
    let(:entity) { Ts::Entity::OrganizationGroup.build(name: "test", code:, parent_code:) }

    it "can read entity" do
      stub_api_request(:get, sub_path, response_body: sucessfull_response_body(entity))

      operation = client.get(entity.code)
      expect(operation.request).to be_kind_of(Ts::Client::Request)
      expect(operation.response).to be_kind_of(Ts::Client::Response)
      expect(operation).to be_success
      expect(operation.entity).to eq entity
    end

    it "can update entity" do
      stub_api_request(:put, sub_path, request_body: entity.to_xml, response_body: sucessfull_response_body(entity))

      operation = client.put(entity.code, entity.to_xml)
      expect(operation).to be_success
      expect(operation.entity).to eq entity
    end

    it "raises error on unexpected http status code" do
      stub_api_request(:get, sub_path, status: 500)
      expect {
        client.get(entity.code)
      }.to raise_error do |error|
        expect(error).to be_a(Ts::Client::Error)
        expect(error.message).to eq "500 Internal Server Error"
        expect(error.operation.request.url).to eq url + sub_path
      end
    end
  end

  context "OrganizationMembership" do
    let(:sub_path) { "/Person/#{person_code}/Membership/#{code}" }
    let(:group_code) { Faker::Internet.uuid }
    let(:role_code) { Faker::Internet.uuid }
    let(:person_code) { Faker::Internet.uuid }

    let(:entity) { Ts::Entity::OrganizationMembership.build(code:, organization_group_code: group_code, organization_role_code: role_code) }
    let(:person) { Ts::Entity::OrganizationPerson.build(code: person_code) }

    subject(:client) { described_class.new(entity.class, nesting: person) }

    it "can read entity" do
      stub_api_request(:get, sub_path, response_body: sucessfull_response_body(entity))

      operation = client.get(entity.code)
      expect(operation).to be_success
      expect(operation.entity).to eq entity
    end

    it "can create entity" do
      stub_api_request(:post, "/Person/#{person_code}/Membership", request_body: entity.to_xml, response_body: sucessfull_response_body(entity))
      response = client.post(entity.to_xml)
      expect(response).to be_success
    end

    it "can update entity" do
      stub_api_request(:put, sub_path, request_body: entity.to_xml, response_body: sucessfull_response_body(entity))

      response = client.put(entity.code, entity.to_xml)
      expect(response).to be_success
      expect(response.entity).to eq entity
    end
  end
end
