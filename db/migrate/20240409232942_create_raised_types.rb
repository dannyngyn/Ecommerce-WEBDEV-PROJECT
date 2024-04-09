class CreateRaisedTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :raised_types do |t|
      t.string :raised_type

      t.timestamps
    end
  end
end
