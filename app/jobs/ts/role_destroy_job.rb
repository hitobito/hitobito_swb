# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Ts::RoleDestroyJob < BaseJob
  self.parameters = [:attrs]

  attr_reader :attrs, :role

  def initialize(attrs)
    @attrs = attrs
    @role = Role.with_inactive.find_by(id: attrs[:id]) || attrs[:type].constantize.new(attrs)
    @role.attributes = attrs.except(:id)
  end

  def perform = (role.ts_interface_put if role.ts_code)
end
