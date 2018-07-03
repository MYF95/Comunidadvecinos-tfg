class AddMonthsToPendingPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :pending_payments, :months, :integer
  end
end
