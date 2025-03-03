# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Car.destroy_all
Car.create([
  { desc: "Toyota Corolla", img: "https://example.com/toyota_corolla.jpg"},
  { desc: "Honda Civic", img: "https://example.com/honda_civic.jpg"},
  { desc: "Ford Mustang", img: "https://example.com/ford_mustang.jpg"},
  { desc: "Chevrolet Malibu", img: "https://example.com/chevrolet_malibu.jpg"},
  { desc: "BMW 3 Series", img: "https://example.com/bmw_3_series.jpg"}
])
