class Food < ApplicationRecord
  belongs_to :user
  has_many_attached :photos
  has_many :claims, dependent: :destroy
  validates :title, presence: true
  validates :kind_of_food, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
