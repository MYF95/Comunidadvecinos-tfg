class Statement < ApplicationRecord
  has_many :statement_movements
  has_many :movements, through: :statement_movements
  has_one_attached :bank_statement

  validates :name, presence: true
  validates :date, presence: true

end
