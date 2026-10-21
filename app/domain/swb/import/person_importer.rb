# frozen_string_literal: true

#  Copyright (c) 2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Import::PersonImporter
  private

  def save_person(import_person, index)
    super.tap do |success|
      role = import_person.role&.becomes(role_type)
      Ts::WriteJob.enqueue_role_post(role) if success && role&.persisted? && role.ts_managed?
    end
  end
end
