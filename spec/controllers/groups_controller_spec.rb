require "spec_helper"

describe GroupsController do
  before { sign_in(people(:admin)) }

  let(:group) { groups(:bvn) }

  context "PUT#update" do
    context "yearly_budget_range" do
      it "can be updated to range" do
        expect(group.yearly_budget_range).to be_nil
        put :update, params: {id: group.id,
                              group: {
                                formatted_yearly_budget_range: "0-5000"
                              }}
        group.reload
        expect(group.yearly_budget_range).to eq(0...5001)
      end

      it "can be updated to nil" do
        group.update!(yearly_budget_range: (0..5000))
        expect(group.yearly_budget_range).to eq(0..5000)
        put :update, params: {id: group.id,
                              group: {
                                formatted_yearly_budget_range: nil
                              }}
        group.reload
        expect(group.yearly_budget_range).to be_nil
      end

      it "can update value to endless range" do
        expect(group.yearly_budget_range).to be_nil
        put :update, params: {id: group.id,
                              group: {
                                formatted_yearly_budget_range: "15000-"
                              }}
        group.reload
        expect(group.yearly_budget_range).to eq(15000...Float::INFINITY)
      end

      it "can not update value outside settings" do
        expect do
          put :update, params: {id: group.id,
                                group: {
                                  formatted_yearly_budget_range: "2-300"
                                }}
        end.to_not change { group.yearly_budget_range }
      end
    end
  end
end
