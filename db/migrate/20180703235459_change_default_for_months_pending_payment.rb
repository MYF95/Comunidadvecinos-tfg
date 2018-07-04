class ChangeDefaultForMonthsPendingPayment < ActiveRecord::Migration[5.2]
  def change
    change_column :pending_payments, :months, :integer, :default => 0
  end
end
