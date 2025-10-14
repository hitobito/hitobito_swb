# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Roles::PromoterJob do
  subject(:job) { described_class.new }

  let(:u15_promotion) { instance_double(Roles::Players::Promotion) }
  let(:u19_promotion) { instance_double(Roles::Players::Promotion) }

  it "promotes u15 and u19 players" do
    # rubocop:todo Layout/LineLength
    expect(Roles::Players::Promotion).to receive(:new).with(Role::Player::JuniorU15).and_return(u15_promotion)
    # rubocop:enable Layout/LineLength
    # rubocop:todo Layout/LineLength
    expect(Roles::Players::Promotion).to receive(:new).with(Role::Player::JuniorU19).and_return(u19_promotion)
    # rubocop:enable Layout/LineLength
    expect(u15_promotion).to receive(:run)
    expect(u19_promotion).to receive(:run)
    job.perform
  end
end
