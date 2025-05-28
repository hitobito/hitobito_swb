# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Event do
  subject(:event) { Fabricate(:event) }

  it "adds phone_numbers to required_contact_attrs by default" do
    expect(event.required_contact_attrs).to eq ["phone_numbers"]
  end
end
