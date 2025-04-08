# frozen_string_literal: true

#  Copyright (c) 2012-2024, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

require "spec_helper"

describe "shared/_ts_info.html.haml" do
  let(:dom) {
    render
    Capybara::Node::Simple.new(@rendered)
  }
  let(:current_user) { people(:admin) }

  before do
    allow(view).to receive(:entry).and_return(entry)
  end

  context "person" do
    let(:entry) { people(:admin) }

    it "renders only link but no log info" do
      expect(dom).to have_link("9034c579-68fe-49f9-b416-24b216a053c6",
        href: "https://web-ts.example.com/organization/member.aspx?mid=9034c579-68fe-49f9-b416-24b216a053c6")
      expect(dom).not_to have_text "Letzte Aktualisierung"
    end

    it "renders only link and log info" do
      Fabricate(:ts_log, subject: entry)
      expect(dom).to have_link("9034c579-68fe-49f9-b416-24b216a053c6",
        href: "https://web-ts.example.com/organization/member.aspx?mid=9034c579-68fe-49f9-b416-24b216a053c6")
      expect(dom).to have_text "Letzte Aktualisierung"
      expect(dom).to have_css(".badge.bg-success", text: "erfolgreich")
    end
  end

  context "group" do
    let(:entry) { groups(:brb) }

    it "renders link to ts" do
      expect(dom).to have_link("89c11ebb-5266-4c0a-8d2a-1cc3a05ff06a",
        href: "https://web-ts.example.com/organization/group.aspx?mid=89c11ebb-5266-4c0a-8d2a-1cc3a05ff06a")
    end

    it "renders only link and log info" do
      Fabricate(:ts_log, subject: entry)
      expect(dom).to have_link("89c11ebb-5266-4c0a-8d2a-1cc3a05ff06a",
        href: "https://web-ts.example.com/organization/group.aspx?mid=89c11ebb-5266-4c0a-8d2a-1cc3a05ff06a")
      expect(dom).to have_text "Letzte Aktualisierung"
      expect(dom).to have_css(".badge.bg-success", text: "erfolgreich")
    end
  end
end
