# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
#
require "spec_helper"

describe Ts::Interface, :tests_ts_api do
  let(:model) { groups(:root) }
  let(:latest_log) { model.ts_latest_log }

  subject(:interface) { described_class.new(model) }

  it "does not fail when config is missing" do
    expect(Ts::Config).to receive(:exist?).and_return(false)
    expect(Rails.logger).to receive(:info).with <<~TEXT.strip
      Ts::Config missing
      METHOD: post
      <OrganizationGroup>
        <Code>368f12eb-1eed-48a0-9381-fa7d42fdcf00</Code>
        <Number>385153371</Number>
        <Name>Swiss Badminton</Name>
        <Contact>not_defined</Contact>
        <Email>lyndon@hitobito.example.com</Email>
        <Address>Schellingstr. 8</Address>
        <PostalCode>4692</PostalCode>
        <City>Charleenhagen</City>
      </OrganizationGroup>
    TEXT
    expect(interface.post).to be_nil
  end

  it "get returns entity from api" do
    stub_api_request(:get, "/Group/#{model.ts_code}",
      response_body: sucessfull_response_body(model.ts_model))
    expect do
      entity = interface.get
      expect(entity).to be_kind_of(Ts::Entity::OrganizationGroup)
    end.not_to change { model.ts_logs.count }
  end

  it "#post puts xml representation to remote and creates log entry" do
    stub_api_request(:post, "/Group", request_body: model.ts_model.to_xml,
      response_body: sucessfull_response_body(model.ts_model))
    expect do
      operation = interface.post
      expect(operation).to be_success
    end.to change { model.ts_logs.count }.by(1)

    # rubocop:todo Layout/LineLength
    expect(latest_log.message).to eq "Created Group::Dachverband Swiss Badminton (385153371, 368f12eb-1eed-48a0-9381-fa7d42fdcf00)"
    # rubocop:enable Layout/LineLength
    expect(latest_log.payload.dig("request", "method")).to eq "post"
    expect(latest_log.payload.dig("request", "url")).to eq url + "/Group"
    expect(latest_log.payload.dig("request", "body")).to eq model.ts_model.to_xml
    expect(latest_log.payload.dig("response", "code")).to eq 200
    expect(latest_log.payload.dig("response", "xml")).to eq sucessfull_response_body(model.ts_model)
  end

  it "#put puts xml representation to remote and creates log entry" do
    stub_api_request(:put, "/Group/#{model.ts_code}", request_body: model.ts_model.to_xml,
      response_body: sucessfull_response_body(model.ts_model))
    expect do
      operation = interface.put
      expect(operation).to be_success
    end.to change { model.ts_logs.count }.by(1)

    # rubocop:todo Layout/LineLength
    expect(latest_log.message).to eq "Updated Group::Dachverband Swiss Badminton (385153371, 368f12eb-1eed-48a0-9381-fa7d42fdcf00)"
    # rubocop:enable Layout/LineLength
    expect(latest_log.payload.dig("request", "method")).to eq "put"
    expect(latest_log.payload.dig("request", "url")).to eq url + "/Group/#{model.ts_code}"
    expect(latest_log.payload.dig("request", "body")).to eq model.ts_model.to_xml
    expect(latest_log.payload.dig("response", "code")).to eq 200
    expect(latest_log.payload.dig("response", "xml")).to eq sucessfull_response_body(model.ts_model)
  end

  it "#put raises when no ts_code is set" do
    model.update!(ts_code: nil)
    expect { interface.put }.to raise_error "Need ts_code"
  end

  describe "errors" do
    it "logs application level error" do
      stub_api_request(:post, "/Group", request_body: model.ts_model.to_xml, status: 422,
        response_body: error_response_body)
      expect do
        interface.post
      end.to change { model.ts_logs.count }.by(1)
      expect(latest_log.payload.dig("request", "method")).to eq "post"
      expect(latest_log.payload.dig("request", "url")).to eq url + "/Group"
      expect(latest_log.payload.dig("request", "body")).to eq model.ts_model.to_xml
      expect(latest_log.payload.dig("response", "code")).to eq 422
      expect(latest_log.payload.dig("response", "xml")).to eq error_response_body
    end

    it "logs internal server error" do
      stub_api_request(:post, "/Group", request_body: model.ts_model.to_xml, status: 500,
        response_body: error_response_body)
      expect do
        interface.post
      end.to change { model.ts_logs.count }.by(1)
      expect(latest_log.payload.dig("request", "method")).to eq "post"
      expect(latest_log.payload.dig("request", "url")).to eq url + "/Group"
      expect(latest_log.payload.dig("request", "body")).to eq model.ts_model.to_xml
      expect(latest_log.payload.dig("response", "code")).to eq 500
      expect(latest_log.payload.dig("response", "xml")).to eq error_response_body
    end
  end

  describe "nesting" do
    let(:group) { groups(:brb_vorstand) }
    let(:person) { people(:admin) }
    let(:ts_code) { Faker::Internet.uuid }

    let(:model) {
      Fabricate(Group::RegionVorstand::Praesident.sti_name, group:, person:, id: 123, ts_code:)
    }

    subject(:interface) { described_class.new(model, nesting: person.ts_model) }

    it "#post uses parent entity in path" do
      stub_api_request(:post, "/Person/#{person.ts_code}/Membership",
        # rubocop:todo Layout/LineLength
        request_body: model.ts_model.to_xml, response_body: sucessfull_response_body(model.ts_model))
      # rubocop:enable Layout/LineLength
      expect do
        operation = interface.post
        expect(operation).to be_success
      end.to change { model.ts_logs.count }.by(1)
    end

    it "#put uses parent entity in path and not ts_code of model" do
      stub_api_request(:put, "/Person/#{person.ts_code}/Membership",
        # rubocop:todo Layout/LineLength
        request_body: model.ts_model.to_xml, response_body: sucessfull_response_body(model.ts_model))
      # rubocop:enable Layout/LineLength
      expect do
        operation = interface.put
        expect(operation).to be_success
      end.to change { model.ts_logs.count }.by(1)
    end

    it "#put raises when parent entity has no code" do
      person.update(ts_code: nil)
      expect { interface.put }.to raise_error "Need nested model ts_code"
    end
  end
end
