class CreateFishOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :fish_orders do |t|
      t.references :fish, null: false, foreign_key: true
      t.references :orders, null: false, foreign_key: true

      t.timestamps
    end
  end
end
