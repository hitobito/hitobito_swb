# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe "event/participation_contact_datas/_fields.html.haml" do
  let(:dom) {
    render
    Capybara::Node::Simple.new(@rendered)
  }
  let(:event) { Fabricate.build(:event, groups: [groups(:root)]) }
  let(:entry) { Event::ParticipationContactData.new(event, Person.new, {}) }
  let(:form_builder) { StandardFormBuilder.new(:participation_contact_data, entry, view, {}) }

  before do
    assign(:policy_finder, instance_double(Group::PrivacyPolicyFinder, acceptance_needed?: false))
    allow(view).to receive(:entry).and_return(entry)
    allow(view).to receive(:fields).and_return(form_builder)
    allow(view).to receive(:f).and_return(form_builder)
  end

  it "renders ts_gender" do
    expect(dom).to have_css "label", text: "Geschlecht"
    expect(dom).to have_css "div[data-form-field-toggle-target=toggle]:not(.hidden)"
    expect(dom).to have_css "label", text: "Geschlecht Spielbetrieb"
  end

  it "has other required fields" do
    expect(dom).to have_css "label", text: "Geburtstag"
    expect(dom).to have_css "label", text: "Adresse"
    expect(dom).to have_css "label", text: "PLZ"
    expect(dom).to have_css "label", text: "Ort"
    expect(dom).to have_css "label", text: "E-Mail"
  end
end
