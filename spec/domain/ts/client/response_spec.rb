# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
require "spec_helper"

describe Ts::Client::Response do
  let(:entity_class) { Ts::Entity::OrganizationGroup }

  let(:code) { 200 }
  let(:http_response) { double("http_response", body: file_fixture("ts/#{file}.xml").read, code:) }

  subject(:response) { described_class.new(entity_class, http_response) }

  describe "sucessful response" do
    let(:file) { :group_update_response }

    it "is as success" do
      expect(response).to be_success
    end

    it "it populates entity" do
      expect(response.entity).to be_present
      expect(response.entity.code).to eq "B8F82FAC-7DED-4C47-B15E-D984D4AD2A1E"
      expect(response.entity.name).to eq ".1001 Freizeit AG (*Member SB)"
      expect(response.entity.number).to eq 8001
    end
  end

  describe "respond with list " do
    let(:entity_class) { Ts::Entity::OrganizationRole }
    let(:file) { :organization_roles }

    it "is a success" do
      expect(response).to be_success
    end

    it "populates entities" do
      expect(response.entities).to have(58).items
    end

    it "uses first of entities as entity" do
      expect(response.entity.code).to eq "A1916683-78A4-4E27-8927-B47C468373A7"
      expect(response.entity.name).to eq "Swiss Badminton Breitensport"
      expect(response.entity.organization_level_code).to eq "C3C1A68D-740B-47CF-9C4F-82E393E41392"
    end
  end

  describe "respond with error" do
    let(:file) { :group_update_response_404 }

    it "is not a success" do
      expect(response).not_to be_success
    end

    it "populates entity" do
      expect(response.entity).to be_blank
    end

    it "populates error" do
      expect(response.error.code).to eq 404
      expect(response.error.message).to match "is not a parent group of a club"
    end
  end

  describe "respond with http but to xml application error" do
    let(:file) { :role_update_404_response }
    let(:code) { 404 }

    it "is not a success" do
      expect(response).not_to be_success
    end

    it "populates entity" do
      expect(response.entity).to be_blank
    end

    it "populates error" do
      expect(response.error.code).to eq 404
      expect(response.error.message).to match "Not Found"
    end
  end
end
