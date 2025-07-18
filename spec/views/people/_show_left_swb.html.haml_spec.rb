# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe "people/_show_left_swb.html.haml" do
  let(:dom) {
    render
    Capybara::Node::Simple.new(@rendered)
  }
  let(:person) { people(:admin) }

  let(:current_user) { people(:member) }

  before do
    allow(view).to receive(:entry).and_return(person.decorate)
    allow(view).to receive(:current_ability).and_return(Ability.new(current_user))
  end

  describe "ts info" do
    it "is not shown when person to people without admin permission" do
      expect(dom).not_to have_css("h2", text: "Tournament Software")
    end

    context "as admin" do
      let(:current_user) { people(:admin) }

      it "is shown when ts_code is set on person" do
        expect(dom).to have_css("h2", text: "Tournament Software")
      end

      it "is not shown when ts_code is missing on person" do
        person.update!(ts_code: nil)
        expect(dom).not_to have_css("h2", text: "Tournament Software")
      end
    end
  end

  it "renders emergency_contact as formatted string" do
    person.update!(emergency_contact: "Foo\nBar")
    expect(dom).to have_css "dt", text: "Notfallkontakt"
    expect(dom).to have_css "dd", text: "Foo\nBar"
  end

  describe "public profile" do
    it "renders public profile link" do
      expect(dom).to have_css "dt", text: "öffentliches Profil"
      expect(dom).to have_css "dd a", text: "https://www.example.com/player/#{person.id}"
    end
  end
end
