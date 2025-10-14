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

  def role
    # rubocop:todo Layout/LineLength
    @role ||= (Role.with_inactive.find_by(id: attrs[:id]) || attrs[:type].constantize.new(attrs)).tap do |r|
      # rubocop:enable Layout/LineLength
      r.attributes = attrs
    end
  end
end
