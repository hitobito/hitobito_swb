# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Group::Budget do
  describe "::list" do
    it "reads from settings" do
      budgets = described_class.list
      expect(budgets).to be_present
      expect(budgets.first).to be_kind_of(described_class)
    end
  end

  it "delegates to_s to value" do
    expect(described_class.new("..5").to_s).to eq "..5"
    expect(described_class.new("5..10").to_s).to eq "5..10"
  end

  it "fails on bad value" do
    expect { described_class.new("..") }.to raise_error(ArgumentError, "invalid Group::Budget: ..")
    expect { described_class.new("a..b") }.to raise_error(ArgumentError, "invalid Group::Budget: a..b")
    expect { described_class.new("5...10") }.to raise_error(ArgumentError, "invalid Group::Budget: 5...10")
  end

  [
    ["..5000", "unter 5000 CHF"],
    ["5000..10000", "5000 - 10000 CHF"],
    ["10000..", "über 10000 CHF"]
  ].each do |value, formatted_string|
    it "formats #{value} as #{formatted_string}" do
      expect(described_class.new(value).to_fs).to eq(formatted_string)
    end
  end
end
