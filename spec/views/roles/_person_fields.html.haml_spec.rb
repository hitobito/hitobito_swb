# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe "roles/_additional_person_fields_swb.html.haml" do
  let(:dom) {
    render "roles/additional_person_fields_swb", fields: form_builder
    Capybara::Node::Simple.new(@rendered)
  }
  let(:group) { groups(:root_gs) }
  let(:entry) { Role.new(group: group, person: Person.new) }
  let(:form_builder) {
    StandardFormBuilder.new(:person, Person.new, view, {
      builder: StandardFormBuilder
    })
  }

  it "does render gender and ts_gender fields" do
    expect(dom).to have_css "label", text: "Geschlecht"
    expect(dom).to have_css "label", text: "Geschlecht Spielbetrieb"
  end
end
