class Tag < ApplicationRecord
  has_many :food_tags, dependent: :destroy
  has_many :foods, through: :food_tags
  validates :name, presence: true, uniqueness: true
end
