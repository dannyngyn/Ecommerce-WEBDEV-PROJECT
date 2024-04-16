class Order < ApplicationRecord
  belongs_to :user
  has_many :fish_orders
end
