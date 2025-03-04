class Car < ApplicationRecord
  belongs_to :user

  validates :desc, presence: true
  validates :img, presence: true
end
