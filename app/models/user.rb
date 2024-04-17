class User < ApplicationRecord
  belongs_to :province
  has_many :user_logins
end
