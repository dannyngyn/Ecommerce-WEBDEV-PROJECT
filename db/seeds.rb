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
require 'nokogiri'
require 'open-uri'
require 'faker'

User.destroy_all
Province.destroy_all
Fish.destroy_all
Water.destroy_all
RaisedType.destroy_all
AdminUser.destroy_all
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

csv_file = Rails.root.join('db/project_fish_data.csv')
csv_data = File.read(csv_file)
fishy_CSV = CSV.parse(csv_data, headers: true)
fish_count = 0

fishy_CSV.each do |f|
  water_type = Water.find_or_create_by(water_type: f["water_type"])
  raised_type = RaisedType.find_or_create_by(raised_type: f["raised_type"])
  if(water_type && water_type.valid?)
    if(raised_type && raised_type.valid?)
      fish = water_type.fishs.create(raised_type: raised_type,
                                    fish_name: f["fish_name"],
                                    stock: f["stock"],
                                    size: f["size"],
                                    fish_cost: f["fish_cost"]
      )
    else
      puts "Raised Type is invalid"
    end
  else
    puts "Water Type is invalid"
  end
end

fish_count = Fish.count
puts "Created #{fish_count} Fish Records w/ CSV"

doc = Nokogiri::HTML(URI.open('https://www.retailcouncil.org/resources/quick-facts/sales-tax-rates-by-province/'))
doc.css('table.table tbody tr').each do |row|
  province_name = row.at_css('td:nth-child(1)').text.strip
  pst = row.at_css('td:nth-child(3)').text.gsub("%", "").to_f
  gst = row.at_css('td:nth-child(4)').text.gsub("%", "").to_f
  hst = row.at_css('td:nth-child(5)').text.gsub("%", "").to_f
  total_tax = pst + gst + hst

  province = Province.find_or_create_by(name: province_name,
                                         gst: gst,
                                         pst: pst,
                                         hst: hst,
                                         total_tax: total_tax
  )
end

province_count = Province.count
puts "Created #{province_count} Province Records w/ Nokogiri Web Scraping"

10.times do
  random_province = Province.order("RANDOM()").take
  if(random_province && random_province.valid?)
    user = random_province.users.create(province_id: random_province,
                                        first_name: Faker::Name.first_name,
                                        last_name: Faker::Name.last_name,
                                        address: Faker::Address.street_address
    )
  end
end

user_count = User.count
puts "Created #{user_count} User Records w/ Faker"