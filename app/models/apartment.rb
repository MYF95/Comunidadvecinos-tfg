class Apartment < ApplicationRecord
  #TODO en caso de que la planta sea 0, que se ponga como BajoºA
  #TODO plantas no pueden estar repetidos

  has_many :user_apartments
  has_many :users, through: :user_apartments

  has_many :apartment_movements
  has_many :movements, through: :apartment_movements

  has_many :apartment_pending_payments
  has_many :pending_payments, through: :apartment_pending_payments, dependent: :destroy

  validates :floor, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :letter, presence: true

end
