class FishOrder < ApplicationRecord
  belongs_to :fish
  belongs_to :order

  def self.ransackable_attributes(_auth_object = nil)
    ["created_at", "fish_id", "id", "id_value", "order_id", "updated_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["fish", "order"]
  end
end
