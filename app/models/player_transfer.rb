# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class PlayerTransfer
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :target_id, :integer
  validates :target_id, presence: true
  validates :target_id, inclusion: {in: ->(t) { t.accepted_targets.pluck(:id) }}, allow_blank: true

  validate :assert_new_role_is_valid

  attr_reader :role

  def initialize(role, attrs = {})
    @role = role
    super(attrs)
  end

  def execute
    ActiveRecord::Base.transaction do
      role.destroy!
      new_role.save!
      Ts::RoleDestroyJob.new(role.ts_destroy_values).enqueue!
      Ts::WriteJob.new(new_role.to_global_id, :post).enqueue!
    end
  end

  def accepted_targets
    @accepted_targets ||= role.group.type.constantize.where.not(id: role.group_id)
  end

  def source = role.group.layer_group

  def target = new_role.group.layer_group

  private

  def new_role
    @new_role ||= Role.new(
      person_id: role.person_id,
      group_id: target_id,
      type: role.type
    )
  end

  def assert_new_role_is_valid
    new_role.unique_across_layers = false # disable that validation

    if errors.none? && !new_role.valid?
      errors.add(:base, :new_role_invalid, details: new_role.errors.full_messages.join(", "))
    end
  end
end
