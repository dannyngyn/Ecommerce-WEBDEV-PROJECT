class FishOrder < ApplicationRecord
  belongs_to :fish
  belongs_to :order

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "fish_id", "id", "id_value", "order_id", "updated_at"]
  end
end
