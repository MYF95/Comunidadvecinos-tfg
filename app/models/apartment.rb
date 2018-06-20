class Apartment < ApplicationRecord
  #TODO en caso de que la planta sea 0, que se ponga como BajoºA

  validates :floor, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :letter, presence: true

end
