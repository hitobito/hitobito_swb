# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe PlayerTransfer do
  let(:role) { roles(:player) }
  let(:source) { role.group }
  let(:target) { groups(:bc_thun_spieler) }
  let(:attrs) { {target_id: target.id} }

  subject(:transfer) { described_class.new(role, attrs) }

  describe "::validations" do
    it "attrs produce valid transfer" do
      expect(transfer).to be_valid
    end

    it "is invalid if target_id is not set" do
      attrs[:target_id] = nil
      expect(transfer).not_to be_valid
      expect(transfer.errors.full_messages).to eq ["Zielverein muss ausgefüllt werden"]
    end

    it "is invalid if transfer does not change target" do
      attrs[:target_id] = role.group_id
      expect(transfer).not_to be_valid
      expect(transfer.errors.full_messages).to eq ["Zielverein ist kein gültiger Wert"]
    end

    it "is invalid if new_role is not valid" do
      Fabricate(Group::VereinSpieler::Aktivmitglied.sti_name, group: target, person: role.person)
      expect(transfer).not_to be_valid
      expect(transfer.errors.full_messages).to eq [
        "Neue Rolle ist nicht gültig (Person hat bereits eine Spielerrolle in dieser Gruppe)"
      ]
    end

    context "role that is unique accross layers" do
      let(:role) { Fabricate(Group::VereinSpieler::Lizenz.sti_name, group: groups(:bc_bern_spieler)) }

      it "attrs produce valid transfer" do
        expect(transfer).to be_valid
      end
    end
  end

  describe "#execute" do
    let(:write_jobs) { Delayed::Job.where("handler ilike '%Ts::WriteJob%'") }
    let(:delete_jobs) { Delayed::Job.where("handler ilike '%Ts::RoleDestroyJob%'") }
    let(:new_role) { Group::VereinSpieler::Aktivmitglied.find_by(group: target) }

    it "creates new and ends old role keeping ts id" do
      expect do
        transfer.execute
      end.to change(target.roles, :count).by(1)
        .and change(source.roles, :count).by(-1)

      expect(new_role.ts_code).to eq role.ts_code
    end

    it "enqueues write and delete job" do
      expect do
        transfer.execute
      end.to change(write_jobs, :count).by(1)
        .and change(delete_jobs, :count).by(1)
      expect(delete_jobs.first.handler).to match(role.id.to_s)
      expect(write_jobs.first.handler).to match(new_role.id.to_s)
    end

    context "role that is unique accross layers" do
      let(:role) { Fabricate(Group::VereinSpieler::Lizenz.sti_name, group: groups(:bc_bern_spieler)) }

      it "creates new and ends old role keeping ts id" do
        expect do
          transfer.execute
        end.to change(target.roles, :count).by(1)
          .and change(source.roles, :count).by(-1)
      end
    end
  end
end
