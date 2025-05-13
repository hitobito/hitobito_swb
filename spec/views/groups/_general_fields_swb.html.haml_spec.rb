# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe "groups/_general_fields_swb.html.haml" do
  let(:dom) {
    render
    Capybara::Node::Simple.new(@rendered)
  }
  let(:form_builder) { StandardFormBuilder.new(:group, group, view, {}) }

  before do
    allow(view).to receive(:entry).and_return(group.decorate)
    allow(view).to receive(:f).and_return(form_builder)
  end

  [:brb, :bc_thun].each do |key|
    context key do
      let(:group) { groups(key) }

      it "renders yearly_budget for #{key}" do
        expect(dom).to have_select "Jahresbudget"
      end

      it "renders founded_on for #{key}" do
        expect(dom).to have_field "Gründungsdatum"
      end
    end
  end

  [:root, :root_gs, :tausendeins_freizeit_ag].each do |key|
    context key do
      let(:group) { groups(key) }

      it "does not render yearly_budget for #{key}" do
        expect(dom).not_to have_select "Jahresbudget"
      end

      it "does not render founded_on for #{key}" do
        expect(dom).not_to have_field "Gründungsdatum"
      end
    end
  end
end
