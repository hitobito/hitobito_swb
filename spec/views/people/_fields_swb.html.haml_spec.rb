# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe "people/_fields_swb.html.haml" do
  let(:dom) {
    render
    Capybara::Node::Simple.new(@rendered)
  }
  let(:person) { people(:admin) }
  let(:form_builder) { StandardFormBuilder.new(:person, person, view, {}) }

  before do
    allow(view).to receive(:entry).and_return(person.decorate)
    allow(view).to receive(:f).and_return(form_builder)
  end

  it "renders country select for nationality" do
    expect(dom).to have_select "Nationalität gemäss Pass / ID"
  end

  it "renders international_player_field field" do
    expect(dom).to have_field "Internationale Spieler-ID"
  end

  it "renders emergency_contact field" do
    expect(dom).to have_field "Notfallkontakt"
  end
end
