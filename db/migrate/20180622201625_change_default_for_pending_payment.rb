class ChangeDefaultForPendingPayment < ActiveRecord::Migration[5.2]
  def change
    change_column :pending_payments, :paid, :boolean, :default => false
  end
end
