# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Roles::Players::MarkAsBilled do
  let(:person) { people(:admin) }
  let(:group) { groups(:bc_bern_spieler) }
  let!(:role) { Fabricate(Group::VereinSpieler::Lizenz.sti_name, person:, group:) }

  let(:billing_period) { billing_periods(:current) }

  subject(:billed) { described_class.new(role) }

  def create(type, attrs)
    Fabricate.build(type, person:, group:, end_on: 1.day.ago).tap do |m|
      m.save!(validate: false)
    end
  end

  it "noops if role with cost exists but was not billed yet" do
    create(Group::VereinSpieler::Passivmitglied.sti_name, person:, group:, end_on: 1.day.ago)
    expect { subject.run }.not_to change { BilledModel.count }
  end

  it "noops if billed model exists but was for role without cost" do
    model = create(Group::VereinSpieler::Passivmitglied.sti_name, person:, group:,
      end_on: 1.day.ago)

    Fabricate(:billed_model, billing_period:, model:)
    expect { subject.run }.not_to change { BilledModel.count }
  end

  it "creates if billed model exists and was for role with cost" do
    model = create(Group::VereinSpieler::Aktivmitglied.sti_name, person:, group:, end_on: 1.day.ago)

    Fabricate(:billed_model, billing_period:, model:)
    expect { subject.run }.to change { BilledModel.count }.from(1).to(2)
    expect(BilledModel.where(model: role, billing_period:)).to be_exists
  end
end
