class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: ["confirmed", "canceled"] }
  validate :no_overlapping_rental, on: :create # Appelé uniquement lors de la création d'une nouvelle location

private
  def no_overlapping_rental
    overlapping_rentals = Rental.where(car_id: car_id)
                                .where.not(id: id)  # Exclut cette réservation si elle existe déjà (utile pour l'update)
                                .where("start_date < ? AND end_date > ?", end_date, start_date)  # Vérifie le chevauchement
    if overlapping_rentals.exists?
      errors.add(:base, "This car is already booked for this period!")
    end
  end
end
