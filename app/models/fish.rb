class Fish < ApplicationRecord
  belongs_to :water

  def self.ransackable_associations(auth_object = nil)
    ["water"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "fish_cost", "fish_name", "id", "id_value", "size", "stock", "updated_at", "water_id"]
  end
end
