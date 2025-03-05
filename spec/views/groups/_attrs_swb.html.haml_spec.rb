#  Copyright (c) 2012-2024, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

require "spec_helper"

describe "groups/_attrs_swb.html.haml" do
  let(:dom) {
    render
    Capybara::Node::Simple.new(@rendered)
  }
  let(:current_user) { people(:admin) }

  before do
    assign(:group, group)
    assign(:sub_groups, "Gruppen" => [], "Untergruppen" => [])

    allow(view).to receive(:entry).and_return(group.decorate)
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:current_user).and_return(current_user)
  end

  let(:dom) { Capybara::Node::Simple.new(@rendered) }

  [:brb, :bc_thun].each do |key|
    context key do
      let(:group) { groups(key) }

      it "renders founded_on field" do
        group.update!(founded_on: Date.new(2020, 3, 31))
        render
        expect(dom).to have_css "dt", text: "Gründungsdatum"
        expect(dom).to have_css "dd", text: "31.03.2020"
      end

      it "renders yearly_budget field" do
        group.update!(yearly_budget: ..5000)
        render
        expect(dom).to have_css "dt", text: "Jahresbudget"
        expect(dom).to have_css "dd", text: "unter 5000 CHF"
      end
    end
  end

  [:root, :root_geschaeftsstelle, :tausendeins_freizeit_ag].each do |key|
    context key do
      let(:group) { groups(key) }

      it "does not render additional fields for #{key}" do
        render
        expect(dom).not_to have_css "dt", text: "Gründungsdatum"
        expect(dom).not_to have_css "dt", text: "Jahresbudget"
      end
    end
  end
end
