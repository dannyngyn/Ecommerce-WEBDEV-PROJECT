class AddTotalTaxToProvince < ActiveRecord::Migration[7.1]
  def change
    add_column :provinces, :total_tax, :float
  end
end
