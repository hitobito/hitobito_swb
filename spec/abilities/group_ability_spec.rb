# frozen_string_literal: true

#  Copyright (c) 2012-2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe GroupAbility do
  subject { ability }

  let(:ability) { Ability.new(role.person.reload) }

  context "player" do
    let(:group) { groups(:brb_spieler) }
    let(:person) { Fabricate(:person) }
    let(:role) { Fabricate(Group::RegionSpieler::Aktivmitglied.sti_name, person:, group:) }

    %i[read index_events index_mailing_lists].each do |action|
      it "may #{action} on player group" do
        expect(ability).to be_able_to(action, group)
      end

      it "may #{action} on region" do
        expect(ability).to be_able_to(action, group.parent)
      end

      if action == :read
        it "may #{action} on root" do
          expect(ability).to be_able_to(action, groups(:root))
        end
      else
        it "may not #{action} on root" do
          expect(ability).not_to be_able_to(action, groups(:root))
        end
      end

      it "may not #{action} on child of root" do
        expect(ability).not_to be_able_to(action, groups(:root_vs))
      end

      it "may not #{action} on another region" do
        expect(ability).not_to be_able_to(action, groups(:bvn))
      end
    end
  end

  describe "index_deleted_people" do
    let(:role) { Fabricate(role_type.sti_name, person: Fabricate(:person), group:) }

    shared_examples "may index deleted people everywhere" do
      [:root, :brb, :bc_bern].each do |layer|
        it "may index deleted people on #{layer}" do
          expect(ability).to be_able_to(:index_deleted_people, groups(layer))
        end
      end
    end

    context "as geschaeftsstelle with layer_and_below_full" do
      let(:group) { groups(:root_gs) }
      let(:role_type) { Group::DachverbandGeschaeftsstelle::Interclub }

      it_behaves_like "may index deleted people everywhere"
    end

    context "as dachverband administrator" do
      let(:group) { groups(:root) }
      let(:role_type) { Group::Dachverband::Administrator }

      it_behaves_like "may index deleted people everywhere"
    end

    context "as geschaeftsstelle mitglied" do
      let(:group) { groups(:root_gs) }
      let(:role_type) { Group::DachverbandGeschaeftsstelle::Mitglied }

      it "may not index deleted people on root" do
        expect(ability).not_to be_able_to(:index_deleted_people, groups(:root))
      end
    end

    context "as dachverband vorstand with layer_full" do
      let(:group) { groups(:root_vs) }
      let(:role_type) { Group::DachverbandVorstand::Praesident }

      it "may not index deleted people on root" do
        expect(ability).not_to be_able_to(:index_deleted_people, groups(:root))
      end
    end

    context "as region administrator with layer_and_below_full" do
      let(:group) { groups(:brb_vorstand) }
      let(:role_type) { Group::RegionVorstand::Administrator }

      it "may not index deleted people on own region" do
        expect(ability).not_to be_able_to(:index_deleted_people, groups(:brb))
      end

      it "may not index deleted people on verein below" do
        expect(ability).not_to be_able_to(:index_deleted_people, groups(:bc_bern))
      end
    end

    context "as verein administrator with layer_full" do
      let(:group) { groups(:bc_bern_vorstand) }
      let(:role_type) { Group::VereinVorstand::Administrator }

      it "may not index deleted people on own verein" do
        expect(ability).not_to be_able_to(:index_deleted_people, groups(:bc_bern))
      end
    end
  end
end
