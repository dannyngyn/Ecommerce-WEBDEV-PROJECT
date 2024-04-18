class Water < ApplicationRecord
  has_many :fishs, dependent: :destroy
  validates :water_type, presence: true

  def self.ransackable_associations(_auth_object = nil)
    ["fishs"]
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["created_at", "id", "id_value", "updated_at", "water_type"]
  end
end
