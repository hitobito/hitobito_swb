# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe InvoiceLists::RolesFee do
  subject(:fixed_fee) { described_class.new(:roles) }

  let(:bern_spieler) { groups(:bc_bern_spieler) }
  let(:bc_bern) { groups(:bc_bern_vorstand) }

  describe "receivers" do
    subject(:receivers) { fixed_fee.receivers }

    let!(:recipient) { Fabricate(Group::VereinVorstand::Finanzen.sti_name, group: bc_bern) }
    let!(:player) { Fabricate(Group::VereinSpieler::Aktivmitglied.sti_name, group: bern_spieler, person: people(:leader)) }

    it "includes recipient" do
      expect(receivers.roles).to eq [recipient]
    end

    it "includes recipient if player was billed for previous but not for current season" do
      Fabricate(:billed_model, model: player, billing_period: billing_periods(:previous))
      expect(receivers.roles).to eq [recipient]
    end

    it "is empty if player was alreadyed billed for current season" do
      Fabricate(:billed_model, model: player, billing_period: billing_periods(:current))
      expect(receivers.roles).to be_empty
    end
  end

  describe "items" do
    let(:thun_spieler) { groups(:bc_thun_spieler) }
    let(:items_by_key) { fixed_fee.items.select(&:present?).index_by(&:key) }

    before do
      Fabricate(Group::VereinVorstand::Finanzen.sti_name, group: bc_bern)
      Fabricate(Group::VereinVorstand::Finanzen.sti_name, group: groups(:bc_thun_vorstand))
    end

    it "counts player if billed in previous season" do
      player, _ = 2.times.map { Fabricate(Group::VereinSpieler::Aktivmitglied.sti_name, group: bern_spieler) }
      Fabricate(:billed_model, model: player, billing_period: billing_periods(:previous))
      expect(items_by_key["aktiv"].count).to eq 2
    end

    it "ignores player if already billed in current season" do
      player, _ = 2.times.map { Fabricate(Group::VereinSpieler::Aktivmitglied.sti_name, group: bern_spieler) }
      Fabricate(:billed_model, model: player, billing_period: billing_periods(:current))
      expect(items_by_key["aktiv"].count).to eq 1
    end

    it "counts and sums roles for group" do
      2.times { Fabricate(Group::VereinSpieler::Aktivmitglied.sti_name, group: bern_spieler) }
      3.times { Fabricate(Group::VereinSpieler::Aktivmitglied.sti_name, group: thun_spieler) }
      3.times { Fabricate(Group::VereinSpieler::Passivmitglied.sti_name, group: bern_spieler) }
      Fabricate(Group::VereinSpieler::JuniorU19.sti_name, group: thun_spieler, person: Fabricate(:person, birthday: 17.years.ago))

      expect(items_by_key["aktiv"].count).to eq 5
      expect(items_by_key["aktiv"].unit_cost).to eq 30
      expect(items_by_key["aktiv"].total_cost).to eq 150

      expect(items_by_key["passiv"].count).to eq 3
      expect(items_by_key["passiv"].unit_cost).to eq 0
      expect(items_by_key["passiv"].total_cost).to eq 0

      expect(items_by_key["junior_u19"].count).to eq 1
      expect(items_by_key["junior_u19"].unit_cost).to eq 40
      expect(items_by_key["junior_u19"].total_cost).to eq 40
    end
  end
end
