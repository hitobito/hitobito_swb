# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe "people/_details_swb.html.haml" do
  let(:dom) {
    render
    Capybara::Node::Simple.new(@rendered)
  }
  let(:current_user) { people(:admin).tap(&:valid?) }

  before do
    allow(view).to receive(:entry).and_return(current_user.decorate)
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:current_user).and_return(current_user)
  end

  let(:dom) { Capybara::Node::Simple.new(@rendered) }

  it "renders ts_gender with label" do
    current_user.update!(gender: nil, ts_gender: :w)
    render
    expect(dom).to have_css "dl:nth-of-type(1) div:nth-child(1) dt", text: "Geschlecht Spielbetrieb"
    expect(dom).to have_css "dl:nth-of-type(1) div:nth-child(1) dd", text: "weiblich"
  end

  it "renders member_id and international member-id" do
    current_user.update!(id: 123, international_player_id: 321)
    render
    expect(dom).to have_css "dl:nth-of-type(2) div:nth-child(1) dt", text: "Member-ID"
    expect(dom).to have_css "dl:nth-of-type(2) div:nth-child(1) dd", text: 123
    expect(dom).to have_css "dl:nth-of-type(2) div:nth-child(2) dt", text: "Internationale Spieler-ID"
    expect(dom).to have_css "dl:nth-of-type(2) div:nth-child(2) dd", text: 321
  end

  it "renders nationality" do
    current_user.update!(nationality: "CH")
    render
    expect(dom).to have_css "dl:nth-of-type(3) div:nth-child(1) dt", text: "Nationalität gemäss Pass / ID"
    expect(dom).to have_css "dl:nth-of-type(3) div:nth-child(1) dd", text: "Schweiz"
  end
end
