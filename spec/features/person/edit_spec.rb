# frozen_string_literal: true

#  Copyright (c) 2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe PeopleController, js: true do
  let(:person) { people(:player) }

  before { sign_in(person) }

  describe "ts_gender field visibility" do
    context "with gender" do
      before do
        person.update_columns(gender: "m")
        visit edit_group_person_path(group_id: person.primary_group_id, id: person)
      end

      it "hides ts_gender field" do
        expect(page).to have_css "label", text: "Geschlecht Spielbetrieb", visible: false
      end

      it "shows ts_gender field when unbekannt is selected" do
        choose "unbekannt"
        expect(page).to have_css "label", text: "Geschlecht Spielbetrieb", visible: true
      end
    end

    context "without gender" do
      before do
        person.update_columns(gender: nil)
        visit edit_group_person_path(group_id: person.primary_group_id, id: person)
      end

      it "shows ts_gender field" do
        expect(page).to have_css "label", text: "Geschlecht Spielbetrieb", visible: true
      end

      it "hides ts_gender field when weiblich is selected" do
        within "#person_gender_radio_group" do
          choose "weiblich"
        end

        expect(page).to have_css "label", text: "Geschlecht Spielbetrieb", visible: false
      end
    end
  end
end
