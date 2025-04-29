# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Export::Tabular::People::PeopleAddress do
  subject(:people_list) { Export::Tabular::People::PeopleAddress.new([people(:admin)]) }

  it "includes member_id in attributes" do
    expect(people_list.attributes).to include :member_id
  end
end
