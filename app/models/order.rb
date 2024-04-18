class Order < ApplicationRecord
  belongs_to :user
  has_many :fish_orders
  validates :total_cost, presence: true, numericality: {greater_than_or_equal_to: 0}

  def self.ransackable_associations(auth_object = nil)
    ["fish_orders", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "payment_status", "total_cost", "updated_at", "user_id", "payment_id"]
  end
end
