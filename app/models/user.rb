class User < ApplicationRecord

  has_one_attached :avatar

  has_many :foods, dependent: :destroy
  has_many :claims, dependent: :destroy
  has_many :reviews, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  geocoded_by :post_code
  after_validation :geocode, if: :will_save_change_to_post_code?

  def average_rating_for_own_foods
    avg = foods.joins(:reviews).average('reviews.rating')
    avg && avg.to_f
  end
end
