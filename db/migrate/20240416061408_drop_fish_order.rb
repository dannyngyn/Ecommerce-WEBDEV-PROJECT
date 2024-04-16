class DropFishOrder < ActiveRecord::Migration[7.1]
  def change
    drop_table :fish_orders
  end
end
