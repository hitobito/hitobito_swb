# frozen_string_literal: true

#  Copyright (c) 2025, Hitobito AG. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::PersonDecorator
  extend ActiveSupport::Concern

  def full_label
    [super, model.id].compact.join("; ")
  end
end
