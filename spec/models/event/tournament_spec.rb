#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Event::Tournament do
  it "has limited roles" do
    expect(described_class.role_types).to eq [
      Event::Role::Leader,
      Event::Role::AssistantLeader,
      Event::Role::Helper,
      Event::Role::Participant
    ]
  end

  it "only uses name, description and external_link attributes" do
    expect(described_class.used_attributes).to eq [
      :name,
      :maximum_participants,
      :contact_id,
      :description,
      :location,
      :application_opening_at,
      :application_closing_at,
      :application_conditions,
      :applications_cancelable,
      :required_contact_attrs,
      :hidden_contact_attrs,
      :participations_visible,
      :globally_visible,
      :minimum_participants
    ]
  end
end
