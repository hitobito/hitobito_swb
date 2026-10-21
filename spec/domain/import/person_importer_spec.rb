# frozen_string_literal: true

#  Copyright (c) 2026, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Import::PersonImporter do
  let(:group) { groups(:bc_bern_spieler) }
  let(:role_type) { Group::VereinSpieler::Aktivmitglied }
  let(:email) { "max.muster@example.com" }
  let(:attrs) do
    {first_name: "Max", last_name: "Muster", email:, street: "Musterweg", housenumber: "1",
     zip_code: "3000", town: "Bern", country: "CH", nationality: "CH", birthday: "1990-01-01",
     gender: "m", phone_number_mobile: "+41 77 123 45 67"}
  end

  let(:write_jobs) { Delayed::Job.where("handler ilike '%Ts::WriteJob%'").order(:run_at) }
  let(:enqueued_writes) do
    write_jobs.map(&:payload_object).map { |job| [job.entity, job.operation] }
  end

  subject(:importer) do
    described_class.new([attrs], group, role_type).tap do |importer|
      importer.user_ability = Ability.new(people(:admin))
    end
  end

  it "enqueues creating the person and then the role in ts" do
    expect { expect(importer.import).to eq(true) }.to change { Person.count }.by(1)

    person = Person.find_by!(email:)
    expect(enqueued_writes).to eq [[person, :post], [person.roles.first, :post]]
  end

  context "for a person existing in ts" do
    let!(:person) { Fabricate(:person, email:, ts_code: Faker::Internet.uuid) }

    it "enqueues creating only the role in ts" do
      expect { expect(importer.import).to eq(true) }.to change { person.roles.count }.by(1)

      expect(enqueued_writes).to eq [[person.roles.reload.first, :post]]
    end
  end

  context "with a role not managed by ts" do
    let(:group) { groups(:bc_bern) }
    let(:role_type) { Group::Verein::Ausbildung }

    it "enqueues nothing" do
      expect { expect(importer.import).to eq(true) }.to change { Person.count }.by(1)

      expect(write_jobs).to be_empty
    end
  end
end
