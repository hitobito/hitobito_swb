# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Roles::Players::Phases
  class Base
    attr_reader :range

    def initialize(role, string = nil)
      @range = parse_date(string) if string
      @checker = Roles::Players::Checker.new(role)
    end

    def active? = range.cover?(Time.zone.today)

    def create? = false

    def update? = false

    def destroy? = false

    private

    attr_reader :checker

    def parse_date(string)
      start_on, end_on = string.split(" - ").map { |s| Date.parse(s) }
      end_on += 1.year if end_on < start_on

      Range.new(start_on, end_on)
    end
  end
end
