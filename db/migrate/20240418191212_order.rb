class Order < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :gst, :float
    add_column :orders, :pst, :float
    add_column :orders, :hst, :float
  end
end
