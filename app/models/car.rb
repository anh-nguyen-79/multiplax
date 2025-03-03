class Car < ApplicationRecord
  belongs_to :user

  validates :desc, presence: true
  validates :img, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
