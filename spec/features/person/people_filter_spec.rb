#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz, Pfadibewegung Schweiz.
#  This file is part of hitobito and licensed under the Affero General Public
#  License version 3 or later. See the COPYING file at the top-level
#  directory or at https://github.com/hitobito/hitobito.

require "spec_helper"

describe PeopleController, js: true do
  let(:group) { groups(:root_gs) }

  context "attributes" do
    before do
      sign_in(people(:admin))
      visit group_people_path(group_id: group.id)

      click_link "Weitere Ansichten"
      click_link "Neuer Filter..."
      expect(page).to have_content "Personen filtern"
      click_link "Felder"
    end

    it "is possible to filter nationality" do
      find("#attribute_filter option", text: "Nationalität gemäss Pass / ID").click
      expect(page).to have_css ".country_select_field"
    end

    it "is possible to filter nationality_badminton" do
      find("#attribute_filter option", text: "Nationalität als Badmintonspieler:in").click
      expect(page).to have_css ".country_select_field"
    end
  end
end
