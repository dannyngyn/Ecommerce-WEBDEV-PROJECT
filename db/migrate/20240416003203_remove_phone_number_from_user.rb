class RemovePhoneNumberFromUser < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :phone_number, :string
  end
end
