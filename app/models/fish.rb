class Fish < ApplicationRecord
  belongs_to :water
  belongs_to :raised_type
  validates :fish_name, presence: true
  validates :stock, presence: true
  validates :size, presence: true
  validates :fish_cost, presence: true
  has_one_attached :image

  validate

  def self.search_by(search,search_id)
    if (search == "" && search_id)
      if search_id == "4"
        all
      else
        where(("water_id = :id"), id: "#{search_id}")
      end
    elsif search_id == "4" && search
      where(("LOWER(fish_name) LIKE :search"), search: "%#{search.downcase}%")
    else
      where(("LOWER(fish_name) LIKE :search AND water_id = :id"), search: "%#{search.downcase}%", id: "#{search_id}")
    end
  end

  def self.ransackable_associations(auth_object = nil)
    ["raised_type", "water"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "fish_cost", "fish_name", "id", "id_value", "size", "stock", "updated_at", "water_id", "raised_type_id"]
  end
end
