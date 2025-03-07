class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :car

  # ✅ Ajout des statuts de réservation en Enum
  enum status: { pending: "pending", confirmed: "confirmed", canceled: "canceled", rejected: "rejected" }

  # ✅ Validations générales
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: statuses.keys }  # Assure que le statut est valide

  # ✅ Validation de cohérence des dates
  validate :valid_dates
  validate :no_overlapping_rental, on: :create  # Vérifie les conflits uniquement à la création

  private

  # ✅ Vérifie que `end_date` est après `start_date`
  def valid_dates
    if start_date && end_date && start_date >= end_date
      errors.add(:end_date, "must be after the start date")
    end
  end

  # ✅ Vérifie qu'il n'y a pas d'autres locations sur la même période pour cette voiture
  def no_overlapping_rental
    overlapping_rentals = Rental.where(car_id: car_id)
                                .where.not(id: id)  # Exclut cette réservation si elle existe déjà (utile pour l'update)
                                .where("start_date < ? AND end_date > ?", end_date, start_date)  # Vérifie les conflits

    if overlapping_rentals.exists?
      errors.add(:base, "🚨 Car already booked on this period!")
    end
  end
end
