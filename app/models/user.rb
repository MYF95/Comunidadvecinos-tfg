class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #TODO Devise flash messages in español

  has_many :user_apartments
  has_many :apartments, through: :user_apartments
end
