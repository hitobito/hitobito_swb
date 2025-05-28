#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Event::Tournament do
  it "has limited roles" do
    expect(described_class.role_types).to eq [
      Event::Role::Leader,
      Event::Role::AssistantLeader,
      Event::Role::Helper,
      Event::Role::Participant
    ]
  end

  it "only uses name, description and external_link attributes" do
    expect(described_class.used_attributes).to eq [
      :name,
      :maximum_participants,
      :contact_id,
      :description,
      :location,
      :application_opening_at,
      :application_closing_at,
      :application_conditions,
      :applications_cancelable,
      :required_contact_attrs,
      :hidden_contact_attrs,
      :participations_visible,
      :globally_visible,
      :minimum_participants,
      :automatic_assignment
    ]
  end

  describe "#init_questions" do
    before(:all) do
      SeedFu.quiet = true
      load HitobitoSwb::Wagon.root.join("db", "seeds", "event_questions.rb").to_s
    end

    let(:tournament) { Fabricate.build(:tournament).tap(&:init_questions) }
    let(:question) { tournament.application_questions.first }

    it "builds single application question" do
      expect(tournament.application_questions).to have(1).item
    end

    answers = ["HE / SM", "DE / SD", "HD / DM", "DD / DD", "MX / DX"].join(", ")
    [
      ["de", "In welchen Disziplinen tritts du an?", answers],
      ["fr", "Dans quelles disciplines concourrez-vous?", answers],
      ["it", "In quali discipline gareggia?", answers],
      ["en", "In which disciplines do you compete?", answers]
    ].each do |locale, text, answers|
      it "has expected question and answer for #{locale}" do
        expect(I18n.with_locale(locale) { question.question }).to eq text
        expect(I18n.with_locale(locale) { question.choices }).to eq answers.to_s
        expect(question.disclosure).to eq "required"
        expect(question.multiple_choices).to eq true
      end
    end
  end
end
