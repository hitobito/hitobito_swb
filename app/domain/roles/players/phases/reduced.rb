module Roles::Players::Phases
  class Reduced < Base
    def create?
      checker.upgrade? || checker.new_role?
    end

    def update?
      checker.upgrade?
    end
  end
end
