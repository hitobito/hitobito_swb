module Roles::Players::Phases
  class Restricted < Base
    def update?
      checker.upgrade?
    end
  end
end
