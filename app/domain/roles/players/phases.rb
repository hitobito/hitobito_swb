module Roles::Players::Phases
  def active(role)
    phases = Settings.roles.phases.map do |key, phase_string|
      const_get(key.to_s.classify).new(phase_string, role)
    end
    phases.find(&:active?)
  end

  module_function :active
end
