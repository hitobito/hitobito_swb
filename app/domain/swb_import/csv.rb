# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module SwbImport
  class Csv
    attr_reader :target, :lines, :filter

    EMPTY_LINE_REGEX = /^(?:,\s*)+$/

    def initialize(file, lines: nil, filter: nil)
      @target = Wagons.all[0].root.join("tmp/#{file}.csv")
      @lines = lines
      @filter = filter
    end

    def csv = @csv ||= filtered(parse_csv)

    def parse_csv = CSV.parse(readlines, headers: true, skip_blanks: true,
      skip_lines: EMPTY_LINE_REGEX)

    def readlines = lines ? target.readlines.take(lines).join : target.read

    def filtered(csv) = filter ? csv.select { |row| filter.call(row) } : csv
  end
end
