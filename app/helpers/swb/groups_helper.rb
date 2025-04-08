# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::GroupsHelper
  def format_yearly_budget(group)
    Group::Budget.new(group.yearly_budget).to_fs if group.yearly_budget
  end

  def format_group_ts_code(group)
    link_to(group.ts_code,
      "#{Ts::Config.web_host}/organization/group.aspx?mid=#{group.ts_code}")
  end
end
