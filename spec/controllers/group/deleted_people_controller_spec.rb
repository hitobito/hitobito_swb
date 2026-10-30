# frozen_string_literal: true

#  Copyright (c) 2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Group::DeletedPeopleController do
  let(:group) { groups(:bc_bern) }

  it "renders index for geschaeftsstelle" do
    sign_in(people(:leader))
    get :index, params: {group_id: group.id}
    expect(response).to render_template("group/deleted_people/index")
  end

  it "denies access for verein administrator" do
    admin = Fabricate(Group::VereinVorstand::Administrator.sti_name,
      group: groups(:bc_bern_vorstand)).person
    sign_in(admin)
    expect do
      get :index, params: {group_id: group.id}
    end.to raise_error(CanCan::AccessDenied)
  end
end
