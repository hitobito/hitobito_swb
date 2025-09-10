# frozen_string_literal: true

#  Copyright (c) 2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Group::VereinVorstand do
  let(:person) { Fabricate(:person) }
  let(:vorstand) { groups(:bc_bern_vorstand) }
  let(:spieler) { groups(:bc_bern_spieler) }

  described_class.role_types.each do |klass|
    it "#{klass.sti_name} can :index_people on players" do
      role = Fabricate(klass.sti_name, person:, group: vorstand)
      expect(Ability.new(role.person)).to be_able_to(:index_people, spieler)
    end
  end

  it "Group::Verein::Interclub can :index_people on players" do
    role = Fabricate(Group::Verein::Interclub.sti_name, person:, group: vorstand.layer_group)
    expect(Ability.new(role.person)).to be_able_to(:index_people, spieler)
  end
end
