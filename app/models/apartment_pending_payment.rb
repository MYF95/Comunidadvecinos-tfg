class ApartmentPendingPayment < ApplicationRecord
  belongs_to :apartment
  belongs_to :pending_payment

end
