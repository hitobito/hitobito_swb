# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Ts::RoleDestroyJob do
  let(:person) { people(:admin) }
  let(:role) { Fabricate(Group::Region::Interclub.sti_name, person:, group: groups(:brb), ts_code: Faker::Internet.uuid) }
  let(:interface) { instance_double(Ts::Interface) }
  let(:attrs) { %w[id code group_id person_id start_on] }

  it "uses interface to post" do
    expect(Ts::Interface).to receive(:new) do |role_proxy, args|
      expect(args[:nesting]).to eq person.ts_model
      expect(role_proxy.attributes.compact_blank.symbolize_keys).to eq role.ts_destroy_values
    end.and_return(interface)
    expect(interface).to receive(:put)
    described_class.new(role.ts_destroy_values).perform
  end
end
