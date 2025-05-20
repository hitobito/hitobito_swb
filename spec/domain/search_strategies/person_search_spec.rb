# frozen_string_literal: true

#  Copyright (c) 2025, Hitobito AG. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe SearchStrategies::PersonSearch do
  describe "#search_fulltext" do
    let(:user) { people(:admin) }

    it "finds accessible person by id" do
      result = search_class(user.id.to_s).search_fulltext

      expect(result).to include(user)
    end
  end

  def search_class(term = nil, page = nil)
    described_class.new(user, term, page)
  end
end
