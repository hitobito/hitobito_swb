# frozen_string_literal: true

#  Copyright (c) 2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Role::LicenseValidation do
  let(:group) { groups(:bc_bern_spieler) }
  let(:person) { people(:admin) }

  subject(:model) { Fabricate(Group::VereinSpieler::LizenzPlus.sti_name, person:, group:) }

  it "sets end_on to 14.6 of next year when current date is after 14.6" do
    travel_to(Date.new(2000, 8, 1)) do
      expect(model.end_on).to eq Date.new(2001, 6, 14)
    end
  end

  it "sets end_on to 14.6 of same year when current date is before 14.6" do
    travel_to(Date.new(2000, 1, 1)) do
      expect(model.end_on).to eq Date.new(2000, 6, 14)
    end
  end

  it "sets end_on to 14.6" do
    travel_to(Date.new(2000, 6, 14)) do
      expect(model.end_on).to eq Date.new(2001, 6, 14)
    end
  end

  it "validates end_on to be readonly" do
    model.end_on = 10.days.from_now
    expect(model).not_to be_valid
    expect(model.errors.full_messages).to eq ["Bis darf nicht verändert werden"]
  end
end
