# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Roles::Players::Promotion do
  def create_spieler(role_type, group, birthday:)
    offset = role_type.year_range.end - 1
    Fabricate(role_type.sti_name, group:,
      person: Fabricate(:person, birthday: offset.years.ago)).then do |role|
      role.person.tap { |p| p.update_columns(birthday:) }
    end
  end

  context "JuniorU15" do
    subject(:promotion) { described_class.new(Role::Player::JuniorU15) }

    let(:group) { groups(:bc_bern_spieler) }
    let(:log) { HitobitoLogEntry.last }
    let(:write_jobs) { Delayed::Job.where("handler ilike '%Ts::WriteJob%'") }
    let(:delete_jobs) { Delayed::Job.where("handler ilike '%Ts::RoleDestroyJob%'") }

    describe "single role" do
      let(:person) { Fabricate(:person, birthday: 10.years.ago) }

      let!(:role) { Fabricate(Group::VereinSpieler::JuniorU15.sti_name, group:, person:) }

      it "noops if person is within limit no exceeded limit" do
        person.update_columns(birthday: 14.years.ago.beginning_of_year)
        expect do
          promotion.run
        end.not_to change { person.reload.roles.map(&:type) }
      end

      it "promotes to JuniorU19" do
        person.update_columns(birthday: 15.years.ago.beginning_of_year)
        expect do
          promotion.run
        end.to change { person.reload.roles.map(&:type) }
          .from(%w[Group::VereinSpieler::JuniorU15])
          .to(%w[Group::VereinSpieler::JuniorU19])
          .and change { delete_jobs.count }.by(1)
          .and change { write_jobs.count }.by(1)
          .and change { HitobitoLogEntry.count }.by(1)
          .and not_change { Role.count }

        expect(write_jobs.first.payload_object.gid).to eq person.roles.first.to_global_id
        expect(write_jobs.first.payload_object.operation).to eq :post
        expect(delete_jobs.first.payload_object.attrs).to eq role.ts_destroy_values
        # rubocop:todo Layout/LineLength
        expect(log.subject).to eq person.roles.find_by(type: Group::VereinSpieler::JuniorU19.sti_name)
        # rubocop:enable Layout/LineLength
        expect(log.category).to eq "promotion"
        expect(log.level).to eq "info"
        expect(log.message).to start_with "Promoted Junior:in (bis U15)"
        expect { role.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "promotes to Lizenz if outside of U19 year range" do
        person.update_columns(birthday: 19.years.ago)
        expect do
          promotion.run
        end.to change { person.reload.roles.map(&:type) }
          .from(%w[Group::VereinSpieler::JuniorU15])
          .to(%w[Group::VereinSpieler::Lizenz])
          .and change { delete_jobs.count }.by(1)
          .and change { write_jobs.count }.by(1)
      end

      describe "failures" do
        before { person.update_columns(birthday: 16.years.ago) }

        it "writes log and notifies error trackers" do
          Group.where(id: group.id).delete_all
          expect(Airbrake).to receive(:notify)
          expect(Sentry).to receive(:capture_exception)
          expect do
            promotion.run
          end.to change { HitobitoLogEntry.count }.by(1)
          expect(log.subject).to eq role
          expect(log.category).to eq "promotion"
          expect(log.level).to eq "error"
          expect(log.message).to start_with "Failed to promote Junior:in (bis U15)"
        end

        it "continues with promotion if one fails" do
          thun_spieler = create_spieler(Group::VereinSpieler::JuniorU15, groups(:bc_thun_spieler),
            birthday: 17.years.ago)
          Group.where(id: group.id).delete_all
          expect do
            promotion.run
          end.to change { thun_spieler.reload.roles.map(&:type) }
            .from(%w[Group::VereinSpieler::JuniorU15])
            .to(%w[Group::VereinSpieler::JuniorU19])
        end
      end
    end

    it "promotes multiple types of JuniorU15 roles" do
      thun_spieler = create_spieler(Group::VereinSpieler::JuniorU15, groups(:bc_thun_spieler),
        birthday: 17.years.ago)
      region_spieler = create_spieler(Group::RegionSpieler::JuniorU15, groups(:brb_spieler),
        birthday: 19.years.ago)
      root_spieler = create_spieler(Group::DachverbandSpieler::JuniorU15,
        # rubocop:todo Layout/LineLength
        Fabricate(Group::DachverbandSpieler.sti_name, parent: groups(:root)), birthday: 17.years.ago)
      # rubocop:enable Layout/LineLength
      expect do
        promotion.run
      end.not_to change { Role.count }
      expect(thun_spieler.roles.first.type).to eq "Group::VereinSpieler::JuniorU19"
      expect(region_spieler.roles.first.type).to eq "Group::RegionSpieler::Lizenz"
      expect(root_spieler.roles.first.type).to eq "Group::DachverbandSpieler::JuniorU19"
    end
  end

  context "JuniorU19" do
    subject(:promotion) { described_class.new(Role::Player::JuniorU19) }

    it "noops if person is within limit no exceeded limit" do
      person = create_spieler(Group::VereinSpieler::JuniorU19, groups(:bc_thun_spieler),
        birthday: 18.years.ago.beginning_of_year)
      expect do
        promotion.run
      end.to not_change { person.reload.roles.map(&:type) }
        .and not_change { person.reload.roles.map(&:updated_at) }
    end

    it "promotes to Lizenz if outside of U19 year range" do
      person = create_spieler(Group::VereinSpieler::JuniorU19, groups(:bc_thun_spieler),
        birthday: 19.years.ago.end_of_year)
      expect do
        promotion.run
      end.to change { person.reload.roles.map(&:type) }
        .from(%w[Group::VereinSpieler::JuniorU19])
        .to(%w[Group::VereinSpieler::Lizenz])
    end

    it "promotes multiple types of JuniorU19 roles" do
      thun_spieler = create_spieler(Group::VereinSpieler::JuniorU19, groups(:bc_thun_spieler),
        birthday: 19.years.ago)
      region_spieler = create_spieler(Group::RegionSpieler::JuniorU19, groups(:brb_spieler),
        birthday: 20.years.ago)
      root_spieler = create_spieler(Group::DachverbandSpieler::JuniorU19,
        # rubocop:todo Layout/LineLength
        Fabricate(Group::DachverbandSpieler.sti_name, parent: groups(:root)), birthday: 20.years.ago)
      # rubocop:enable Layout/LineLength
      expect do
        described_class.new(Role::Player::JuniorU19).run
      end.not_to change { Role.count }
      expect(thun_spieler.roles.first.type).to eq "Group::VereinSpieler::Lizenz"
      expect(region_spieler.roles.first.type).to eq "Group::RegionSpieler::Lizenz"
      expect(root_spieler.roles.first.type).to eq "Group::DachverbandSpieler::Lizenz"
    end
  end
end
