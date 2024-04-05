# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'csv'

Water.destroy_all
Fish.destroy_all
AdminUser.destroy_all
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

csv_file = Rails.root.join('db/project_fish_data.csv')
csv_data = File.read(csv_file)
fishy_CSV = CSV.parse(csv_data, headers: true)
fish_count = 0

fishy_CSV.each do |f|
  water_type = Water.find_or_create_by(water_type: f["water_type"])
  if(water_type && water_type.valid?)
    fish = water_type.fishs.create(fish_name: f["fish_name"],
                                  stock: f["stock"],
                                  size: f["size"],
                                  fish_cost: f["fish_cost"]
    )
  else
    puts "Water Type is invalid"
  end
end

fish_count = Fish.count

puts "Created #{fish_count} Fish Records w/ CSV"