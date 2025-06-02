# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Roles::Players::Phases do
  describe "::active" do
    let(:role) { roles(:member) }

    [
      [(Date.new(2025, 6, 15)..Date.new(2025, 8, 15)), Roles::Players::Phases::Open],
      [(Date.new(2025, 8, 16)..Date.new(2025, 12, 31)), Roles::Players::Phases::Reduced],
      [(Date.new(2025, 1, 1)..Date.new(2025, 6, 14)), Roles::Players::Phases::Restricted]
    ].each do |range, phase|
      it "#{range} is covered by #{phase}" do
        travel_to(range.begin) do
          expect(described_class.active(role)).to be_kind_of(phase)
        end
        travel_to(range.to_a.sample) do
          expect(described_class.active(role)).to be_kind_of(phase)
        end
        travel_to(range.end) do
          expect(described_class.active(role)).to be_kind_of(phase)
        end
      end
    end
  end
end
