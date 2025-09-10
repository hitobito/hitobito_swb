# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class MakeVereinAndRegionContactablesPrivate < ActiveRecord::Migration[7.1] # rubocop:disable Rails/ReversibleMigrationMethodDefinition

  def up
    change_contactable_public_flag(Group::Verein, Group::Region, public: false)
  end

  private

  def change_contactable_public_flag(*group_types, public:)
    contactable_types = [AdditionalEmail, SocialAccount, PhoneNumber]
    contactable_types.each do |contactable_type|
      contactable_type
        .where(contactable_type: Group.sti_name, contactable_id: Group.where(type: group_types.map(&:sti_name)).select(:id))
        .update_all(public:)
    end
  end
end
