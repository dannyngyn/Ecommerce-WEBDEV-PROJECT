class FishOrder < ApplicationRecord
  belongs_to :fish
  belongs_to :order
end
