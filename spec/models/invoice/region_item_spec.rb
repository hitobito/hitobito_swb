# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Invoice::RegionItem do
  let(:group) { groups(:root) }
  let(:recipient_groups) { Group.where(id: [group.id]) }
  let(:invoice) { Fabricate(:invoice, group:) }
  let(:attrs) {
    {
      invoice:,
      account: "1234",
      cost_center: "5678",
      name: "invoice item",
      dynamic_cost_parameters: {
        unit_cost: 10.50,
        period_start_on: 1.year.ago,
        period_end_on: 1.day.ago
      }
    }
  }

  subject(:item) { described_class.for_groups(recipient_groups, **attrs) }

  context "validation" do
    it "is valid" do
      expect(item).to be_valid
    end

    it "is invalid without period start" do
      item.dynamic_cost_parameters[:period_start_on] = nil
      expect(item).not_to be_valid
    end

    it "is valid without period end" do
      item.dynamic_cost_parameters[:period_end_on] = nil
      expect(item).to be_valid
    end

    it "is invalid with wrong unit_cost value" do
      item.dynamic_cost_parameters[:unit_cost] = "foobar"
      expect(item).not_to be_valid
    end

    it "is invalid with nil unit_cost" do
      item.dynamic_cost_parameters[:unit_cost] = nil
      expect(item).not_to be_valid
    end
  end

  describe "#count" do
    before { Group::Region.destroy_all }

    it "is 0 without any regions" do
      expect(item.count).to eq 0
    end

    it "counts regions" do
      Fabricate(Group::Region.name, parent: group, created_at: 2.years.ago)
      expect(item.count).to eq 1
    end

    it "excludes group of other type" do
      Fabricate(Group::Center.name, parent: group, created_at: 2.years.ago)
      expect(item.count).to eq 0
    end

    it "excludes regions which are not descendants" do
      Fabricate(Group::Region.name, parent: nil, created_at: 2.years.ago)
      expect(item.count).to eq 0
    end

    it "excludes regions which were created after period end" do
      Fabricate(Group::Region.name, parent: group, created_at: DateTime.now)
      expect(item.count).to eq 0
    end

    it "excludes regions which were archived before period start" do
      Fabricate(Group::Region.name, parent: group, created_at: 2.years.ago,
        archived_at: 400.days.ago)
      expect(item.count).to eq 0
    end

    it "excludes regions which were deleted before period start" do
      Fabricate(Group::Region.name, parent: group, created_at: 2.years.ago,
        deleted_at: 400.days.ago)
      expect(item.count).to eq 0
    end

    context "for layer" do
      let!(:region) { Fabricate(Group::Region.name, parent: group, created_at: 2.years.ago) }
      let!(:region2) { Fabricate(Group::Region.name, parent: group, created_at: 2.years.ago) }

      subject(:item) { described_class.for_groups(region, **attrs) }

      it "counts 1 for the addressed region" do
        expect(item.count).to eq 1
      end
    end
  end

  describe "#dynamic_cost" do
    before { Group::Region.destroy_all }

    it "multiplies price and count" do
      2.times { Fabricate(Group::Region.name, parent: group, created_at: 2.years.ago) }
      expect(item.dynamic_cost).to eq(21.00)
    end
  end
end
