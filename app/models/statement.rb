class Statement < ApplicationRecord
  has_many :statement_movements
  has_many :movements, through: :statement_movements

  validates :name, presence: true
  validates :date, presence: true

end
