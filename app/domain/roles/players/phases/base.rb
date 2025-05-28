module Roles::Players::Phases
  class Base
    attr_reader :range, :checker
    def initialize(string, role)
      start_on, end_on = string.split(" - ").map { |s| Date.parse(s) }
      end_on += 1.year if end_on < start_on

      @range = Range.new(start_on, end_on)
      @checker = Roles::Players::Checker.new(role)
    end

    def active? = range.cover?(Time.zone.today)

    def create? = false

    def update? = false

    def destroy? = false
  end
end
