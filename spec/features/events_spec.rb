# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe "Events" do
  let(:person) { people(:admin) }
  let(:group) { groups(:root) }

  before { sign_in(person) }

  xdescribe "ExternalTraining" do
    let!(:training) do
      allow(RestClient).to receive(:get).and_return(double("response", code: 200))
      Fabricate(:external_training, group_ids: [group.id])
    end

    it "can view external trainings on group" do
      click_on "Swiss Badminton"
      within("#content") do
        click_on "Externe Ausbildungen"
      end
      expect(page).to have_content training.name
    end

    it "can view external trainings top level" do
      within("#page-navigation") do
        click_on "Externe Ausbildungen"
        expect(page).to have_content training.name
      end
    end
  end
end
