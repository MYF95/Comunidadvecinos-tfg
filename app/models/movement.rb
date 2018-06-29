class Movement < ApplicationRecord
  has_many :statement_movements
  has_many :statements, through: :statement_movements

  has_one :apartment_movement
  has_one :apartment, through: :apartment_movement

  validates :concept, presence: true
  validates :date, presence: true
  validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}

end
