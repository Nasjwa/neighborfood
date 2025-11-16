class Claim < ApplicationRecord
  before_validation :set_default_status, on: :create
  belongs_to :user
  belongs_to :food

  validate :collect_time

  private

  def set_default_status
    self.status ||= "pending"
  end

end
