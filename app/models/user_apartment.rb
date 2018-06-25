class UserApartment < ApplicationRecord
  belongs_to :user
  belongs_to :apartment

  validates :apartment_id, :uniqueness => {:scope => :user_id, message: 'el usuario ya está en la vivienda'}
end
