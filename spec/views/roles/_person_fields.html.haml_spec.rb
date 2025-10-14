# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe "roles/_additional_person_fields_swb.html.haml" do
  let(:dom) {
    render
    Capybara::Node::Simple.new(@rendered)
  }
  let(:group) { groups(:root_gs) }
  let(:entry) { Role.new(group: group, person: Person.new) }

  before do
    allow(view).to receive(:fields).and_return(StandardFormBuilder.new(:person, Person.new, view,
      {}))
  end

  it "does render gender and ts_gender fields" do
    expect(dom).to have_css "label", text: "Geschlecht"
    expect(dom).to have_css "label", text: "Geschlecht Spielbetrieb"
  end
end
