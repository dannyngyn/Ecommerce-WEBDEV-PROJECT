class CreateWaters < ActiveRecord::Migration[7.1]
  def change
    create_table :waters do |t|
      t.string :water_type

      t.timestamps
    end
  end
end
