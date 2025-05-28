class InvoiceItem::Roles < InvoiceItem
  attr_accessor :roles

  has_many :billed_models,
    inverse_of: :invoice_item,
    foreign_key: :invoice_item_id,
    dependent: :delete_all

  after_create :create_billed_models

  private

  def create_billed_models
    rows = roles.map do |role|
      {
        invoice_item_id: id,
        billing_period_id: BillingPeriod.active.id,
        model_id: role.id,
        model_type: Role.sti_name
      }
    end
    BilledModel.insert_all(rows)
  end
end
