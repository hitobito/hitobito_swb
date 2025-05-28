# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe InvoiceLists::FixedFee do
  let(:person) { people(:admin) }

  subject(:fixed_fee) { described_class.for(name) }

  subject(:items) { fixed_fee.items }

  subject(:item_names) { fixed_fee.items.map(&:name) }

  subject(:sum) { items.sum(&:total_cost) }

  it "raises when not found" do
    expect { described_class.for(:foobar) }.to raise_error(RuntimeError, "No config exists for foobar")
  end

  describe "roles" do
    let(:name) { :roles }

    it "has 9 configured and translated items" do
      expect(fixed_fee).to have(9).items
      expect(item_names).to eq [
        "Aktivmitglieder",
        "Passivmitglieder",
        "Junior:innen (bis U-15)",
        "Junior:innen (U17-U19)",
        "Lizenzen",
        "Lizenzen Plus",
        "Lizenen NO ranking",
        "Lizenzen Plus Junior:innen (U19)",
        "Vereinigungsspieler:innen"
      ]
    end
  end

  describe "regions" do
    let(:name) { :regions }
    let(:item) { items.first }
    let(:layer_group_ids) { Group::Region.pluck(:id) }

    it "has single translated item" do
      expect(item_names).to eq ["Grundbeitrag Region"]
    end

    context "with receivers" do
      before do
        Fabricate(Group::Region::Finanzen.sti_name, group: groups(:brb), person:)
        Fabricate(Group::Region::Finanzen.sti_name, group: groups(:bvn), person:)
      end

      it "has single item with sum of 1000" do
        expect(fixed_fee).to have(1).item
        expect(sum).to eq 1000
      end

      it "has count of two and cost of 500" do
        expect(item.count).to eq 2
        expect(item.unit_cost).to eq 500
      end
    end
  end

  describe "teams" do
    let(:name) { :teams }
    let(:layer_group_ids) { Group::Verein.pluck(:id) }

    it "has 9 configured items" do
      expect(fixed_fee).to have(9).items

      expect(item_names).to eq [
        "Grundbeitrag",
        "Grundbeitrag reduziert",
        "NLA",
        "NLB",
        "1. Liga",
        "2. Liga",
        "3. und 4. Liga",
        "Junioren, Senioren und 5. Liga Teams",
        "Vereinigung"
      ]
    end

    it "has expected sum of 60 for two vereine" do
      Fabricate(Group::Verein::Finanzen.sti_name, group: groups(:bc_bern), person:)
      Fabricate(Group::Verein::Finanzen.sti_name, group: groups(:bc_thun), person:)
      expect(sum).to eq 60
    end
  end
end
