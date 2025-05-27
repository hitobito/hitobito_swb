require "spec_helper"

describe BillingPeriod do
  describe "::active" do
    it "returns the active billing_period" do
      expect(described_class.active).to eq billing_periods(:current)
    end
  end

  describe "::validates" do
    it "cannot have two active periods" do
      previous = billing_periods(:previous)
      previous.active = true
      expect(previous).not_to be_valid
      expect(previous.errors.full_messages).to eq ["Es kann nur eine aktive Rechnungsperiode geben"]
    end

    it "cannot still change active period" do
      billing_periods(:current).update(active: false)
      expect(BillingPeriod.active).to be_nil
      previous = billing_periods(:previous)
      previous.active = true
      expect(previous).to be_valid
    end
  end
end
