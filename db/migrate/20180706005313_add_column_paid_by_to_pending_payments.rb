class AddColumnPaidByToPendingPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :pending_payments, :paid_by, :string
  end
end
