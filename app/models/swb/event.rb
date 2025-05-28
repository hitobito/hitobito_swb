# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Event
  extend ActiveSupport::Concern

  prepended do
    before_validation :add_phone_number_to_required_contact_attrs
  end

  def add_phone_number_to_required_contact_attrs
    self.required_contact_attrs |= ["phone_numbers"]
  end
end
