class AddBillingNameToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :billing_name, :string
  end
end
