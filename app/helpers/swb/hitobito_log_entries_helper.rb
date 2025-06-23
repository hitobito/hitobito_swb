# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::HitobitoLogEntriesHelper
  def format_hitobito_log_entry_subject(e)
    case e.subject
    when Role then link_to(e.subject.person, e.subject.person)
    else f(e, :subject)
    end
  end
end
