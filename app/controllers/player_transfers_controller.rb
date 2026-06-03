# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class PlayerTransfersController < ApplicationController
  prepend Nestable
  include DryCrud::InstanceVariables # needed for nesting
  include WithCurrentAdmin

  self.nesting = [Group, Role]

  alias_method :role, :parent
  helper_method :role, :player_transfer, :targets

  before_action :run_authorization_check
  before_action :prevent_lizenz_plus_change

  def create
    if player_transfer.valid? && player_transfer.execute
      redirect_to group_people_path(parents.first), notice: success_message
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def player_transfer
    @player_transfer ||= PlayerTransfer.new(parent, model_params)
  end

  def targets
    @targets ||= player_transfer.accepted_targets.includes(:layer_group).map { |g|
      [g.id, g.layer_group.to_s]
    }.sort_by(&:second)
  end

  def prevent_lizenz_plus_change
    if role.is_a?(Role::LizenzPlus) && !Current.admin
      redirect_to(group_person_path(parents.first, role.person),
        alert: t(".failure_only_admin_can_transfer_lizenz_plus"))
    end
  end

  def run_authorization_check
    authorize!(:update, role)
    @person = role.person # required for sheet
  end

  def model_params
    if params.key?(:player_transfer)
      params.require(:player_transfer).permit([:target_id])
    end
  end

  def success_message
    t(".success", source: player_transfer.source, target: player_transfer.target)
  end
end
