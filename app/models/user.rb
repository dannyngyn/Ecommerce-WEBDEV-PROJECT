class User < ApplicationRecord
  belongs_to :province
  has_many :orders
  has_many :user_logins

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: true
  validates :email, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["address", "created_at", "email", "first_name", "id", "id_value", "last_name", "province_id", "updated_at"]
  end

end
