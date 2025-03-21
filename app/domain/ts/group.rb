# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
class Ts::Group
  attr_reader :client

  delegate :put, :get, to: :client

  def initialize(group)
    @client = Ts::Client.new(group)
  end

  def get
    parent_organization_group(client.get)
  end

  def parent_organization_group(xml)
    Hash.from_xml(xml).dig("Result", "OrganizationGroup", "ParentOrganizationGroup", "Code")
  end
end
