class Apartment < ApplicationRecord
  #TODO en caso de que la planta sea 0, que se ponga como BajoºA
  #TODO plantas no pueden estar repetidos

  has_many :user_apartments
  has_many :users, through: :user_apartments

  validates :floor, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :letter, presence: true

end
