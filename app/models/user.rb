class User < ApplicationRecord
  belongs_to :province
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["province"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["address", "created_at", "first_name", "id", "id_value", "last_name", "province_id", "updated_at"]
  end
end
