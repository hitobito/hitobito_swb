# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe Ts::WriteJob do
  let(:person) { people(:admin) }
  let(:interface) { instance_double(Ts::Interface) }

  it "uses interface to post" do
    expect(Ts::Interface).to receive(:new).with(person).and_return(interface)
    expect(interface).to receive(:post)
    described_class.new(person.to_global_id, :post).perform
  end

  it "uses interface to put" do
    expect(Ts::Interface).to receive(:new).with(person).and_return(interface)
    expect(interface).to receive(:put)
    described_class.new(person.to_global_id, :put).perform
  end
end
