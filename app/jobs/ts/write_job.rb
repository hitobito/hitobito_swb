# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Ts::WriteJob < BaseJob
  self.parameters = [:gid, :operation]

  attr_reader :gid, :operation

  def initialize(gid, operation)
    @gid = gid
    @operation = operation
  end

  def perform
    entity.send(:"ts_interface_#{operation}")
  end

  def entity
    @entity ||= GlobalID::Locator.locate(@gid)
  end
end
