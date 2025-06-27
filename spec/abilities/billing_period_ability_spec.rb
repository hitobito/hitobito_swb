# frozen_string_literal: true

#  Copyright (c) 2025, Swiss Badminton. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas

require "spec_helper"

describe BillingPeriodAbility do
  let(:current) { billing_periods(:current) }
  let(:previous) { billing_periods(:previous) }

  subject(:ability) { Ability.new(people(:admin)) }

  it "may destroy inactive" do
    expect(ability).to be_able_to(:destroy, previous)
  end

  it "may not destroy active" do
    expect(ability).not_to be_able_to(:destroy, current)
  end
end
