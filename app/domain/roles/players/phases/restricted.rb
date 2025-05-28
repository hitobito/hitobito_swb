module Roles::Players::Phases
  class Restricted < Base
    def create?
      checker.junior_role? && checker.new_role?
    end
  end
end
