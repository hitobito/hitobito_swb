# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Event::ParticipationContactDatasController do
  before { sign_in(admin) }

  let(:admin) { people(:admin) }
  let(:group) { groups(:root) }
  let(:course) { Fabricate(:event, groups: [group]) }
  let(:entry) { assigns(:participation_contact_data) }

  context "PATCH#update" do
    it "creates person" do
      course.update_columns(required_contact_attrs: [])

      patch :update, params: {
        group_id: group.id,
        event_id: course.id,
        event_participation_contact_data: Fabricate.build(:person).attributes.merge(
          phone_numbers_attributes: {"1" => {translated_label: :mobile, number: "0771234567"}}
        ),
        event_role: {
          type: "Event::Role::Participant"
        }
      }

      expect(entry).to have(0).errors
    end

    it "validates default attrs" do
      patch :update, params: {
        group_id: group.id,
        event_id: course.id,
        event_participation_contact_data: {}
      }
      expect(entry).to have(11).errors
      expect(entry.errors.attribute_names).to match_array([:birthday, :country, :email, :first_name, :last_name, :phone_numbers, :street, :town, :zip_code, :nationality, :ts_gender])
    end
  end
end
