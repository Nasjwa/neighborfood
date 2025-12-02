class Review < ApplicationRecord
  belongs_to :user
  belongs_to :food

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true

  after_save :update_user_average_rating

  def update_user_average_rating
    user.update!(
      average_rating: user.reviews.average(:rating)
    )
  end
end
