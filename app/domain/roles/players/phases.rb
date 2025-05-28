module Roles::Players::Phases
  class Base
    attr_reader :range
    def initialize(string)
      dates = string.split(" - ").map { |s| Date.parse(s) }
      @range = Range.new(*dates)
    end

    def create? = false

    def update? = false

    def destroy? = false
  end

  def active
    Settings.roles.phases.map do |key, phase|
      const_get(key.to_s.classify).new(phase)
    end.find(&:active?)
  end

  module_function :active
end
