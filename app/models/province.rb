class Province < ApplicationRecord
  has_many :users, dependent: :destroy
  validates :name, presence: true

  def self.ransackable_associations(_auth_object = nil)
    ["users"]
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["created_at", "gst", "hst", "id", "id_value", "name", "pst", "total_tax", "updated_at"]
  end
end
