# frozen_string_literal: true

#  Copyright (c) 2025, Hitobito AG. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe PersonDecorator do
  let(:person) do
    Fabricate.build(:person, {
      id: 123,
      first_name: "Max",
      last_name: "Muster",
      nickname: "Maxi",
      town: "Bern",
      birthday: "14.2.2014"
    })
  end

  describe "#as_typeahead" do
    subject(:label) { person.decorate.as_typeahead[:label] }

    it "includes id" do
      expect(label).to eq "Max Muster / Maxi, Bern (2014); 123"
    end
  end
end
