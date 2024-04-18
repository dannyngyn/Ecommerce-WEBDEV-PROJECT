class RemoveBillingNameFromOrders < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :billing_name, :string
  end
end
