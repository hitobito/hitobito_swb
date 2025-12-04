# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Invoice::BatchCreate do
  let(:group) { groups(:root) }
  let(:invoice) { group.invoices.last }

  describe "fixed memberhip fee" do
    let(:person) { people(:admin) }
    let!(:run) do
      run = InvoiceRun.new(group: group, title: :title)
      run.invoice = Invoice.new(title: "invoice", group: group, issued_at: Time.zone.today)
      Fabricate(Group::RegionVorstand::Finanzen.sti_name, group: groups(:brb_vorstand), person:)
      InvoiceRuns::FixedFee.for(:regions).prepare(run)
      run.tap(&:save!).reload
    end

    it "includes layer name in title" do
      expect do
        Invoice::BatchCreate.new(run).call
      end.to change { group.invoices.count }.by(1)
      expect(invoice.recipient_address).to eq <<~TEXT.chomp
        Badminton Regionalverband Bern
        Chief Admin
        Voigtslach 57c
        50621 Baderfeld
        FR
      TEXT
    end
  end
end
