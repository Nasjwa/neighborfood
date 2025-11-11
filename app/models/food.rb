class Food < ApplicationRecord
  belongs_to :user
  has_many_attached :photos
  has_many :claims, dependent: :destroy
  has_many :food_tags, dependent: :destroy
  has_many :tags, through: :food_tags
  validates :title, presence: true
  validates :kind_of_food, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  enum kind_of_food: { cooked_meal: 0, groceries: 1 }
end
