class Car < ApplicationRecord
<<<<<<< HEAD
  has_one_attached :img
  belongs_to :user


  validates :desc, presence: true
=======
  # Relation avec le modèle User - optional: true permet de créer une voiture sans utilisateur associé
  # Utile pendant le développement ou pour certains cas d'utilisation spécifiques
  belongs_to :user, optional: true
  
  # Validations plus strictes
  validates :phase, presence: { message: "must be provided" }
  validates :description, presence: { message: "cannot be blank" }
  
  # Rendre obligatoires les champs year, price, location et km
  validates :year, presence: { message: "must be provided" },
                  numericality: { only_integer: true, greater_than: 1900, less_than_or_equal_to: -> { Date.current.year + 1 }, message: "must be a valid year" }
  
  validates :km, presence: { message: "must be provided" },
                numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "must be a positive number" }
  
  validates :price, presence: { message: "must be provided" },
                   numericality: { greater_than: 0, message: "must be greater than zero" }
  
  validates :location, presence: { message: "must be provided" }
  
  # Remplacer la validation img par images si vous utilisez Active Storage
  # validates :img, presence: true
  
  # Association avec Active Storage pour gérer plusieurs images
  has_many_attached :images
>>>>>>> 83f011eab1010289b7ea720c336bfca0d2debb37
end
