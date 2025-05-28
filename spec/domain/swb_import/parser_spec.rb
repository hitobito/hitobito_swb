# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe SwbImport::Parser do
  let(:attrs) {
    {
      address: "Musterstrasse 123a",
      email: "test@example.com",
      phone: "+41 79 123 45 67",
      country: "SUI",
      dob: "1990-01-01",
      language: "Deutsch (SUI)"
    }
  }
  let(:mappings) do
    [
      [:address, :street, :parse_street_from_address],
      [:address, :housenumber, :parse_housenumber_from_address],
      [:email, :email, :parse_email],
      [:phone, :phone, :parse_phone_number],
      [:country, :country, :parse_country],
      [:language, :language, :parse_language],
      [:dob, :birthday, :parse_date]
    ]
  end

  subject(:parser) { described_class.new(attrs, mappings) }

  let(:parsed_data) { parser.parse }

  it "parses the attributes according to the mappings" do
    expect(parsed_data).to eq(
      street: "Musterstrasse",
      housenumber: "123a",
      email: "test@example.com",
      phone: "+41 79 123 45 67",
      country: "CH",
      language: :de,
      birthday: Date.new(1990, 1, 1)
    )
  end

  it "handles nil values" do
    attrs[:phone] = nil
    expect(parsed_data[:phone]).to be_nil
  end

  it "handles invalid phone numbers" do
    attrs[:phone] = "invalid"
    expect(parsed_data[:phone]).to be_nil
  end

  it "handles bad phone number value" do
    attrs[:phone] = "0000000000"
    expect(parsed_data[:phone]).to be_nil
  end

  it "handles invalid dates" do
    attrs[:dob] = "invalid"
    expect(parsed_data[:birthday]).to be_nil
  end

  describe "country" do
    [
      ["AUT", "AT"],
      ["CHN", "CN"],
      ["CRO", "HR"],
      ["DEN", "DK"],
      ["ENG", "GB"],
      ["ESP", "ES"],
      ["FIN", "FI"],
      ["FRA", "FR"],
      ["GER", "DE"],
      ["GUF", "FR"],
      ["IMN", "GB"],
      ["IND", "IN"],
      ["IRQ", "IQ"],
      ["ITA", "IT"],
      ["LIE", "LI"],
      ["NED", "NL"],
      ["POL", "PL"],
      ["SCO", "GB"],
      ["SOM", "SO"],
      ["SUI", "CH"],
      ["SWE", "SE"],
      ["THA", "TH"],
      ["TUR", "TR"],
      ["UAE", "AE"],
      ["UGA", "UG"],
      ["VIE", "VN"],
      ["ZAI", "CD"],
      ["ZIM", "ZW"]
    ].each do |country, parsed|
      it "parses #{country} country to #{parsed}" do
        attrs[:country] = country
        expect(parsed_data[:country]).to eq parsed
      end
    end
  end

  describe "language" do
    [
      ["Deutsch (SUI)", :de],
      ["Deutsch", :de],
      ["deutsch", :de],
      ["Französisch (SUI)", :fr],
      ["Italienisch", :it],
      ["", :de]
    ].each do |language, parsed|
      it "parses #{language} language to #{parsed}" do
        attrs[:language] = language
        expect(parsed_data[:language]).to eq parsed
      end
    end
  end

  describe "email" do
    it "strips whitespaces" do
      attrs[:email] = "bad_ email@example.com"
      expect(parsed_data[:email]).to eq "bad_email@example.com"
    end

    it "replaces (at) convention" do
      attrs[:email] = "bad_ email(at)example.com"
      expect(parsed_data[:email]).to eq "bad_email@example.com"
    end

    it "ignores email with bad syntax" do
      attrs[:email] = "www.bad-email.com"
      expect(parsed_data[:email]).to be_nil
    end
  end
end
