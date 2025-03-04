class Car < ApplicationRecord
  has_one_attached :img
  belongs_to :user


  validates :desc, presence: true
end
