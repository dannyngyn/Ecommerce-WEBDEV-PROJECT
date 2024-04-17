class AddUserReferenceToUserLogin < ActiveRecord::Migration[7.1]
  def change
    add_reference :user_logins, :user, null: true, foreign_key: true
  end
end
