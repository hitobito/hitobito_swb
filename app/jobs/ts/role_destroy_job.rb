# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Ts::RoleDestroyJob < BaseJob
  self.parameters = [:attrs]

  attr_reader :attrs

  def initialize(attrs)
    @attrs = attrs
  end

  def perform = (role.ts_interface_put if role.ts_code)

  private

  def role = @role ||= attrs[:type].constantize.new(attrs)
end
