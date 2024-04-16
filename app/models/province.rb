class Province < ApplicationRecord
  has_many :users
  validates :name, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["users"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gst", "hst", "id", "id_value", "name", "pst", "total_tax", "updated_at"]
  end
end
