# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Devise::ConfirmationsController do
  before { sign_in(people(:admin)) }

  let(:person) { people(:admin) }

  let(:write_jobs) { Delayed::Job.where("handler ilike '%Ts::WriteJob%'") }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:person]
  end

  it "enqueues write job when confirming email" do
    person.update!(ts_code: Faker::Internet.uuid, unconfirmed_email: "dummy@example.com",
      confirmation_token: "ab")
    Fabricate(Group::Region::Interclub.sti_name, person:, group: groups(:brb),
      ts_code: Faker::Internet.uuid)
    expect do
      get :show, params: {confirmation_token: "ab"}
    end.to change { person.reload.email }.from("admin@hitobito.example.com").to("dummy@example.com")
      .and change { write_jobs.count }.by(1)
  end
end
