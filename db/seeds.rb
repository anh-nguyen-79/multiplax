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
User.destroy_all
user = User.first  # Utiliser le premier utilisateur trouvé, ou créer un nouvel utilisateur si nécessaire

# Création de 5 voitures avec des informations fictives
# Création de 5 utilisateurs avec des informations fictives
# Création de 5 utilisateurs avec des informations fictives
users = User.create!([
  { email: "user1@example.com", password: "password1" },
  { email: "user2@example.com", password: "password2" },
  { email: "user3@example.com", password: "password3" },
  { email: "user4@example.com", password: "password4" },
  { email: "user5@example.com", password: "password5" }
])

# Création de 5 voitures en associant un utilisateur à chaque voiture
cars = Car.create!([
  { desc: "Voiture 1", img: "img1.jpg", user_id: users.first.id },
  { desc: "Voiture 2", img: "img2.jpg", user_id: users.second.id },
  { desc: "Voiture 3", img: "img3.jpg", user_id: users.third.id },
  { desc: "Voiture 4", img: "img4.jpg", user_id: users.fourth.id },
  { desc: "Voiture 5", img: "img5.jpg", user_id: users.fifth.id }
])

puts "5 utilisateurs et 5 voitures ont été créés avec succès !"
