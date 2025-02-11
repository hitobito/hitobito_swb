# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

Group::Dachverband.seed_once(:parent_id, name: "Swiss Badminton")
puts "waiting 10 seconds to avoid double creation of default children..."
sleep 10
