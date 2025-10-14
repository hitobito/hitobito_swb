# frozen_string_literal: true

#  Copyright (c) 2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Role::LizenzPlus do
  let(:group) { groups(:bc_bern_spieler) }
  let(:person) { people(:admin) }

  subject(:model) {
    Fabricate.build(Group::VereinSpieler::LizenzPlus.sti_name, person:, group:).tap(&:valid?)
  }

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

  describe "::validations" do
    it "validates end_on on persisted models" do
      expect(model.save!).to eq true
      model.end_on = model.end_on + 1.day
      expect(model).not_to be_valid
      expect(model.errors.full_messages).to eq ["Bis darf nicht verändert werden"]
    end

    it "allows modification if admin" do
      Current.admin = true
      expect(model.save!).to eq true
      model.end_on = model.end_on + 1.day
      expect(model).to be_valid
      Current.admin = false
    end
  end

  it "only Verein has two lizenz plus role types" do
    lizenz_plus_types = [Group::VereinSpieler::LizenzPlus, Group::VereinSpieler::LizenzPlusJunior]
    all_types = [Group::DachverbandSpieler, Group::RegionSpieler,
      Group::VereinSpieler].flat_map(&:role_types)
    (all_types - lizenz_plus_types).each do |type|
      expect(type.new).not_to be_kind_of(Role::LizenzPlus)
    end
    lizenz_plus_types.each do |type|
      expect(type.new).to be_kind_of(Role::LizenzPlus)
    end
  end
end
