class RaisedType < ApplicationRecord
  has_many :fishs, dependent: :destroy
  validates :raised_type, presence: true

  def self.ransackable_associations(_auth_object = nil)
    ["fishs"]
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["created_at", "id", "id_value", "raised_type", "updated_at"]
  end
end
