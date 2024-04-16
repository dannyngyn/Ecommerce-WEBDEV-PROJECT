class DropOrders < ActiveRecord::Migration[7.1]
  def change
    drop_table :orders
  end
end
