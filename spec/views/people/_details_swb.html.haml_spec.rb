# frozen_string_literal: true

#  Copyright (c) 2012-2024, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

require "spec_helper"

describe "people/_details_swb.html.haml" do
  let(:dom) {
    render
    Capybara::Node::Simple.new(@rendered)
  }
  let(:current_user) { people(:admin) }

  before do
    allow(view).to receive(:entry).and_return(current_user.decorate)
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:current_user).and_return(current_user)
  end

  let(:dom) { Capybara::Node::Simple.new(@rendered) }

  it "renders member_id and international member-id" do
    current_user.update!(id: 123, international_player_id: 321)
    render
    expect(dom).to have_css "dl:nth-of-type(1) div:nth-child(1) dt", text: "Member-ID"
    expect(dom).to have_css "dl:nth-of-type(1) div:nth-child(1) dd", text: 123
    expect(dom).to have_css "dl:nth-of-type(1) div:nth-child(2) dt", text: "Internationale Spieler-ID"
    expect(dom).to have_css "dl:nth-of-type(1) div:nth-child(2) dd", text: 321
  end

  it "renders nationality and nationality_badminton" do
    current_user.update!(nationality: "CH", nationality_badminton: "DE")
    render
    expect(dom).to have_css "dl:nth-of-type(2) div:nth-child(1) dt", text: "Nationalität gemäss Pass / ID"
    expect(dom).to have_css "dl:nth-of-type(2) div:nth-child(1) dd", text: "Schweiz"
    expect(dom).to have_css "dl:nth-of-type(2) div:nth-child(2) dt", text: "Nationalität als Badmintonspieler:in"
    expect(dom).to have_css "dl:nth-of-type(2) div:nth-child(2) dd", text: "Deutschland"
  end
end
