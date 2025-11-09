class User < ApplicationRecord
  has_one_attached :avatar

  has_many :foods, dependent: :destroy
  has_many :claims, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
