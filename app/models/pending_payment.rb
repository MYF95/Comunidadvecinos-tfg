class PendingPayment < ApplicationRecord
  before_destroy :destroy_apartment_pending_payments

  has_one :apartment_pending_payment
  has_one :apartment, through: :apartment_pending_payment, dependent: :destroy

  validates :concept, presence: true
  validates :date, presence: true
  validates :amount, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :months, presence: true, numericality: { greater_than_or_equal_to: 0}

  private
    def destroy_apartment_pending_payments
      unless self.apartment.nil?
        self.apartment_pending_payment.destroy
      end
    end
end
