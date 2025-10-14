# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.
#
require "spec_helper"

describe Ts::Entity do
  subject(:entity) { from_xml(file.read) }

  let(:file) { file_fixture("ts/#{described_class.name.demodulize.underscore}.xml") }

  def from_xml(xml) = described_class.from_xml(xml)

  def build(attrs) = described_class.build(attrs)

  shared_examples "ts_entity" do |ignored_members: []|
    (described_class.members - ignored_members).each do |member|
      it "has present #{member}" do
        expect(entity.send(member)).to be_present
      end
    end
  end

  describe Ts::Entity::OrganizationLevel do
    it_behaves_like "ts_entity"

    it "can re-read from xml" do
      obj = build(code: 1, name: 1) # This still has type coversion issues
      expect(from_xml(obj.to_xml)).to eq obj
    end

    it "can generate model as list" do
      xml = Ts::Entity::List.to_xml([build(code: "1", name: "1"), build(code: "2", name: "2")])
      entities = Ts::Entity::List.from_xml(xml)
      expect(entities).to have(2).items
      expect(entities.map(&:code)).to match_array [1, 2]
    end
  end

  describe Ts::Entity::OrganizationGroup do
    # rubocop:todo Layout/LineLength
    it_behaves_like "ts_entity", ignored_members: [:parent_group, :parent_code] # only used for writing
    # rubocop:enable Layout/LineLength
  end

  describe Ts::Entity::OrganizationRole do
    it_behaves_like "ts_entity"
  end

  describe Ts::Entity::OrganizationMembership do
    it_behaves_like "ts_entity", ignored_members: [:name]
  end

  describe Ts::Entity::OrganizationPerson do
    it_behaves_like "ts_entity"

    it "upcases id fields" do
      hash = Hash.from_xml(described_class.build(gender_id: 1, member_id: 2,
        firstname: "test").to_xml)
      expect(hash.dig("OrganizationPerson", "GenderID")).to eq "1"
      expect(hash.dig("OrganizationPerson", "MemberID")).to eq "2"
      expect(hash.dig("OrganizationPerson", "Firstname")).to eq "test"
    end
  end
end
