# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Swb::Event::ParticipationContactData
  extend ActiveSupport::Concern

  prepended do
    additional_attributes = [:ts_gender, :nationality, :nationality_badminton, :international_player_id, :emergency_contact, :advertising, :newsletter]
    self.contact_attrs += additional_attributes

    self.mandatory_contact_attrs += [
      :street, :zip_code, :town, :country, :birthday, :ts_gender, :nationality
    ]
    delegate(*additional_attributes, to: :person)
  end
end
