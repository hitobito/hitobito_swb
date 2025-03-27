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
    current_user.update!(nationality: "CH", nationality_badminton: "DE")

    allow(view).to receive(:entry).and_return(current_user.decorate)
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:current_user).and_return(current_user)
  end

  let(:dom) { Capybara::Node::Simple.new(@rendered) }

  it "renders nationality field" do
    render
    expect(dom).to have_css ".labeled-grid:nth-of-type(1) dt", text: "Nationalität gemäss Pass / ID"
    expect(dom).to have_css ".labeled-grid:nth-of-type(1) dd", text: "Schweiz"
  end

  it "renders yearly_budget field" do
    render
    expect(dom).to have_css ".labeled-grid:nth-of-type(2) dt", text: "Nationalität als Badmintonspieler:in"
    expect(dom).to have_css ".labeled-grid:nth-of-type(2) dd", text: "Deutschland"
  end
end
