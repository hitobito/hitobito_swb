# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
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
end
