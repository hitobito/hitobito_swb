# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Event::ExternalTraining do
  it "is handled externally and has therefor empty role_types" do
    expect(described_class.role_types).to be_empty
  end

  it "only uses name, description and external_link attributes" do
    expect(described_class.used_attributes).to eq [:name, :description, :external_link]
  end

  context "::validations" do
    subject(:training) { Fabricate.build(:external_training) }

    it "validates presence of external link" do
      training.external_link = nil
      expect(training).not_to be_valid
      expect(training.errors.full_messages).to eq ["Externer Link muss ausgefüllt werden"]
    end

    it "validates return code of external link" do
      expect(RestClient).to receive(:get).with("http://example.com/test").and_return(double(
        "response", code: 500
      ))
      training.external_link = "http://example.com/test"
      expect(training).not_to be_valid
      expect(training.errors.full_messages).to eq ["Externer Link ist nicht gültig"]
    end

    it "treats SocketError as invalid link" do
      expect(RestClient).to receive(:get).with("http://example.com/test").and_raise(SocketError)
      training.external_link = "http://example.com/test"
      expect(training).not_to be_valid
      expect(training.errors.full_messages).to eq ["Externer Link ist nicht gültig"]
    end

    it "is valid if external link is valid" do
      expect(RestClient).to receive(:get).with("http://example.com/test").and_return(double(
        "response", code: 200
      ))
      training.external_link = "http://example.com/test"
      expect(training).to be_valid
    end

    it "is invalid if protocol is missing" do
      expect(RestClient).not_to receive(:get)
      training.external_link = "www.example.com/test"
      expect(training).not_to be_valid
      # rubocop:todo Layout/LineLength
      expect(training.errors.full_messages).to eq ["Externer Link muss mit http:// oder https:// beginnen"]
      # rubocop:enable Layout/LineLength
    end
  end

  it "can be created with name, date and external link" do
    training = described_class.new(
      name: "test",
      groups: [groups(:root)],
      external_link: "http://example.com/test",
      dates_attributes: [{start_at: Time.zone.today}]
    )
    allow(RestClient).to receive(:get).with("http://example.com/test").and_return(double(
      "response", code: 200
    ))
    expect(training).to be_valid
    expect(training.save).to eq true
  end
end
