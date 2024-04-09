class Fish < ApplicationRecord
  belongs_to :water

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
    ["water"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "fish_cost", "fish_name", "id", "id_value", "size", "stock", "updated_at", "water_id"]
  end
end
