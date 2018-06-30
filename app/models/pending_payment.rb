class PendingPayment < ApplicationRecord

  has_one :apartment_pending_payment
  has_one :apartment, through: :apartment_pending_payment

  validates :concept, presence: true
  validates :date, presence: true
  validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}

end
