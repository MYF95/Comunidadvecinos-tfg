class ChangeAmountInPendingPaymentType < ActiveRecord::Migration[5.2]
  def change
    change_column :pending_payments, :amount, :float
  end
end
