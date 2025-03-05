# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# On suppose qu'il y a déjà un utilisateur dans la base de données

Rental.destroy_all
Car.destroy_all
User.destroy_all


user = User.first  # Utiliser le premier utilisateur trouvé, ou créer un nouvel utilisateur si nécessaire


users = User.create!([
  { email: "user1@example.com", password: "password1" },
  { email: "user2@example.com", password: "password2" },
  { email: "user3@example.com", password: "password3" },
  # { email: "user4@example.com", password: "password4" },
  # { email: "user5@example.com", password: "password5" }
])




# Création de 5 voitures en associant un utilisateur à chaque voiture
cars = [
  { description: "Voiture 1", user_id: users.first.id, km: 15000, year: 2000, price: 200, location: "Paris", phase: "new" },
  { description: "Voiture 2", user_id: users.first.id, km: 15000, year: 2000, price: 200, location: "Lyon", phase: "used" },
  { description: "Voiture 3", user_id: users.first.id, km: 15000, year: 2000, price: 200, location: "Marseille", phase: "certified" }
]
  # { desc: "Voiture 4", user_id: user.id },
  # { desc: "Voiture 5", user_id: user.id }

cars.each_with_index do |car_attributes, index|
  puts "Creating car"
  car = Car.new(car_attributes)
  puts "Attaching photo"
  file = File.open(Rails.root.join("app/assets/images/car-#{index + 1}.jpg"))
  car.images.attach(io: file, filename: "multiple.jpg", content_type: "image/jpg")
  car.save!
end



puts "5 utilisateurs et 5 voitures ont été créés avec succès !"

rentals = Rental.create!([
  { user_id: users.first.id, car_id: cars.first.id, start_date: "2025-03-01", end_date: "2025-03-05", status: "confirmed", price: 100 },
  { user_id: users.second.id, car_id: cars.second.id, start_date: "2025-03-02", end_date: "2025-03-06", status: "confirmed", price: 200 },
  { user_id: users.third.id, car_id: cars.third.id, start_date: "2025-03-03", end_date: "2025-03-07", status: "confirmed", price: 300 },
  { user_id: users.fourth.id, car_id: cars.fourth.id, start_date: "2025-03-04", end_date: "2025-03-08", status: "confirmed", price: 400 },
  { user_id: users.fifth.id, car_id: cars.fifth.id, start_date: "2025-03-05", end_date: "2025-03-09", status: "confirmed", price: 500 }
])
puts " 5 locations ont été créées avec succès !"

met a jour les 5 voitures, il doivent avoir l'image suivant <img src="<%= asset_path 'fiat.webp' %>" alt="Photo de la voiture" width="300">

