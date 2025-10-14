# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
#
module Swb::RoleListsController
  extend ActiveSupport::Concern

  prepended do
    before_action :redirect_if_modifying_ts_role
  end

  private

  def redirect_if_modifying_ts_role # rubocop:todo Metrics/AbcSize
    creates_ts_role = Role.ts_managed_types.include?(params.dig(:role, :type))
    changes_ts_role = (Role.ts_managed_types & params.fetch(:role, {}).fetch(:types, {}).keys).any?
    if params[:ids]
      deletes_ts_roles = Role.where(id: params[:ids],
        type: Role.ts_managed_types).exists?
    end

    if creates_ts_role || changes_ts_role || deletes_ts_roles
      redirect_to(group_people_path(group), alert: t("role_lists.unsupported_for_ts_role"))
    end
  end
end
