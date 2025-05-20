# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Team < ActiveRecord::Base
  validates_by_schema

  belongs_to :group

  ORDER_STMT = "SUBSTRING(name FROM '^(.*) [0-9]+$'), SUBSTRING(name FROM '[0-9]+')::INT"

  scope :list, -> { order(Arel.sql(ORDER_STMT)) }

  def to_s
    name
  end
end
