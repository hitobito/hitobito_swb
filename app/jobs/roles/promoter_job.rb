# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

class Roles::PromoterJob < RecurringJob
  run_every 1.day

  def perform_internal
    Roles::Players::Promotion.new(Role::Player::JuniorU15).run
    Roles::Players::Promotion.new(Role::Player::JuniorU19).run
  end

  def next_run
    interval.from_now.midnight + 5.minutes
  end
end
