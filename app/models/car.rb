class Car < ApplicationRecord
  # Relation avec le modèle User
  belongs_to :user, optional: true

  # Validations
  validates :phase, presence: { message: "must be provided" }
  validates :description, presence: { message: "cannot be blank" }
  validates :year, presence: { message: "must be provided" },
                  numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: -> { Date.today.year }, message: "must be a valid year" }
  validates :km, presence: { message: "must be provided" },
                numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "must be a positive number" }
  validates :price, presence: { message: "must be provided" },
                   numericality: { greater_than: 0, message: "must be greater than zero" }
  validates :location, presence: { message: "must be provided" }
  validate :images_presence

  # Active Storage
  has_many_attached :images

  # Geocoding
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  # Méthode pour vérifier la disponibilité d'une voiture pour une période donnée
  def available?(start_date, end_date)
    # Convertir en Date si ce sont des chaînes
    start_date = Date.parse(start_date.to_s) unless start_date.is_a?(Date)
    end_date = Date.parse(end_date.to_s) unless end_date.is_a?(Date)
    
    # Vérifier s'il n'y a pas de réservations qui se chevauchent
    !rentals.exists?(
      "(start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?) OR (start_date >= ? AND end_date <= ?)",
      start_date, start_date, end_date, end_date, start_date, end_date
    )
  end
  
  # Scope pour filtrer les voitures disponibles pour une période donnée
  scope :available_between, ->(start_date, end_date) {
    where.not(id: Rental.where(
      "(start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?) OR (start_date >= ? AND end_date <= ?)",
      start_date, start_date, end_date, end_date, start_date, end_date
    ).select(:car_id))
  }

  # Scope pour rechercher par location
  scope :by_location, ->(query) { where("location ILIKE ?", "%#{query}%") }

  private

  def images_presence
    errors.add(:images, "must be attached") unless images.attached?
  end
end
