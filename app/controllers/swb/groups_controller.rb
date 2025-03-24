module Swb::GroupsController
  include ActiveSupport::Concern

  def assign_attributes
    param_range = model_params.delete(:formatted_yearly_budget_range)

    range = param_range if Settings.groups.yearly_budget_ranges.include?(param_range)

    if range
      range = Range.new(*range.split("-", 2).map { _1.presence&.to_i })
    end

    entry.yearly_budget_range = range

    super
  end
end
