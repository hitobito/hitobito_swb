# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe "people/_fields.html.haml" do
  let(:dom) {
    render
    Capybara::Node::Simple.new(@rendered)
  }
  let(:person) { people(:admin) }
  let(:form_builder) { StandardFormBuilder.new(:person, person, view, {}) }

  before do
    allow(view).to receive(:entry).and_return(person.decorate)
    allow(controller).to receive(:current_user).and_return(person)
    allow(view).to receive(:fields).and_return(form_builder)
    allow(view).to receive(:f).and_return(form_builder)
  end

  describe "custom ts_gender field" do
    it "is hidden when gender is not blank" do
      person.gender = "m"
      expect(dom).to have_css "label", text: "Geschlecht"
      expect(dom).to have_css "div[data-form-field-toggle-target=toggle].hidden"
      expect(dom).to have_css ".hidden label", text: "Geschlecht Spielbetrieb"
    end

    it "is visible when gender is blank" do
      person.gender = ""
      expect(dom).to have_css "label", text: "Geschlecht"
      expect(dom).to have_css "div[data-form-field-toggle-target=toggle]:not(.hidden)"
      expect(dom).to have_css "input[name='person[gender]']", count: 3
      expect(dom).to have_css "input[name='person[ts_gender]']", count: 2
    end
  end

  it "renders asterix for gender label" do
    expect(dom).to have_css "label[for='person_gender'].required", text: "Geschlecht"
  end

  it "renders asterix for phone_number label" do
    expect(dom).to have_css "label[for='person_phone_numbers'].required", text: "Telefonnummern"
  end

  it "renders asterix for street label" do
    expect(dom).to have_css "label[for='person_street'].required", text: "Adresse"
  end

  it "renders asterix for zip_town label" do
    expect(dom).to have_css "label[for='person_zip_code'].required", text: "PLZ/Ort"
  end
end
