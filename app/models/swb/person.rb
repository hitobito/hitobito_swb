# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Person
  extend ActiveSupport::Concern

  included do
    self::FILTER_ATTRS << [:nationality, :country_select] << [:nationality_badminton, :country_select]
  end

  def nationality_label
    Countries.label("CH")
  end
end
