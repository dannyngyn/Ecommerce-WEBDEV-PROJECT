class CreateFish < ActiveRecord::Migration[7.1]
  def change
    create_table :fish do |t|
      t.string :fish_name
      t.integer :stock
      t.string :size
      t.float :fish_cost
      t.references :water, null: false, foreign_key: true

      t.timestamps
    end
  end
end
