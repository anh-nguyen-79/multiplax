class Car < ApplicationRecord
  # Relation avec le modèle User
  belongs_to :user, optional: true

  # Validations
  validates :phase, presence: { message: "must be provided" }
  validates :description, presence: { message: "cannot be blank" }
  validates :year, presence: { message: "must be provided" },
                  numericality: { only_integer: true, greater_than: 1900, less_than_or_equal_to: -> { Date.current.year + 1 }, message: "must be a valid year" }
  validates :km, presence: { message: "must be provided" },
                numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "must be a positive number" }
  validates :price, presence: { message: "must be provided" },
                   numericality: { greater_than: 0, message: "must be greater than zero" }
  validates :location, presence: { message: "must be provided" }

  # Active Storage
  has_many_attached :images

  # Geocoding
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
