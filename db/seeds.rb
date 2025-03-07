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



Ben = User.create!(email: "ben@gmail.com", password: "password1")
Anh = User.create!(email: "anh@gmail.com", password: "password2")
Antoine = User.create!(email: "antoine@gmail.com", password: "password3")
Yannick = User.create!(email: "yannick@gmail.com", password: "password4")


# Création de 5 voitures en associant un utilisateur à chaque voiture
cars = [
  { description: "Voiture 1", user_id: Ben.id, km: 17000000, year: 2022, price: 20000, location: "16 rue de la paix, Paris", phase: "Rocket multipla" },
  { description: "Voiture 2", user_id: Anh.id, km: 15000000, year: 2020, price: 21000, location: "12 rue du lac, Annecy", phase: "Star multipla" },
  { description: "Superbe multi plat avec une belle piscine", user_id: Antoine.id, km: 1245, year: 2021, price: 250, location: "2 Quai du Port, 13002 Marseille", phase: "Multipool" },
  { description: "Voiture 4", user_id: Yannick.id, km: 3670, year: 2004, price: 175, location: "15 Rue Royale, 74000 Annecy", phase: "Multisnow" },
  { description: "Voiture 5", user_id: Ben.id, km: 60000, year: 2008, price: 214, location: "45 Boulevard Longchamp, 13001 Marseille", phase: "Multitruck" },
  { description: "Voiture 6", user_id: Anh.id, km: 126000, year: 2000, price: 205, location: "10 Rue de Rivoli, 75004 Paris", phase: "Multi pkm" },
  { description: "Voiture 7", user_id: Antoine.id, km: 46000, year: 2007, price: 201, location: "25 Avenue des Champs-Élysées, 75008 Paris", phase: "Multidreamdark" },
  { description: "Voiture 8", user_id: Yannick.id, km: 28000, year: 2025, price: 150000, location: "5 Boulevard Haussmann, 75009 Paris", phase: "Multi luxe" },
  { description: "Voiture 9", user_id: Ben.id, km: 25380, year: 1994, price: 10, location: "18 Rue de la Paix, 75002 Paris", phase: "Multi old" },
  { description: "Voiture 10", user_id: Anh.id, km: 19035, year: 2018, price: 230, location: "42 Rue de Rennes, 75006 Paris", phase: "Multi fish" },
  { description: "Voiture 11", user_id: Ben.id, km: 23580, year: 2009, price: 153, location: "7 Place Vendôme, 75001 Paris", phase: "Multi nimbus" },
  { description: "Voiture 12", user_id: Anh.id, km: 15000, year: 2000, price: 200, location: "18 Avenue du Prado, 13006 Marseille", phase: "Multi sport" },
  { description: "Voiture 13", user_id: Antoine.id, km: 47000, year: 2004, price: 175, location: "33 Rue du Faubourg Saint-Honoré, 75008 Paris
", phase: "Multi japan" },
  { description: "Voiture 14", user_id: Antoine.id, km: 15000, year: 2009, price: 188, location: "72 Rue de Rome, 13006 Marseille", phase: "Multi Matrix" },
  { description: "Voiture 15", user_id: Ben.id, km: 15000, year: 2011, price: 197, location: "12 Rue Oberkampf, 75011 Paris", phase: "Multi paradise" },
  { description: "Voiture 16", user_id: Anh.id, km: 15000, year: 2002, price: 125, location: "50 Quai de la Rapée, 75012 Paris", phase: "Multi Menthe" },
]
  # { desc: "Voiture 4", user_id: user.id },
  # { desc: "Voiture 5", user_id: user.id }

cars.each_with_index do |car_attributes, index|
  puts "Creating car"
  car = Car.new(car_attributes)
  puts "Attaching photo"
  file = File.open(Rails.root.join("app/assets/images/car-#{index + 1}.jpeg"))
  car.images.attach(io: file, filename: "multiple.jpg", content_type: "image/jpg")
  car.save!
end



puts "4 utilisateurs et 16 voitures ont été créés avec succès !"
