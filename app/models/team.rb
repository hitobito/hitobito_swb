# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Team < ActiveRecord::Base
  TOP_LEAGUES = [
    "NLA",
    "NLB",
    "1. Liga",
    "2. Liga",
    "3. Liga",
    "4. Liga"
  ]

  LEAGUES = [
    *TOP_LEAGUES,
    "NL - 5. Liga",
    "Senioren",
    "Junioren",
    "Vereinigung"
  ]

  ORDER_STMT = "SUBSTRING(name FROM '^(.*) [0-9]+$'), SUBSTRING(name FROM '[0-9]+')::INT"

  validates_by_schema

  belongs_to :group

  validates :league, inclusion: {in: LEAGUES}

  scope :list, -> { order(Arel.sql(ORDER_STMT)) }

  def to_s
    name
  end
end
