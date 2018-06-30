class CreateApartmentPendingPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :apartment_pending_payments do |t|
      t.integer :apartment_id
      t.integer :pending_payment_id

      t.timestamps
    end
    add_index :apartment_pending_payments, :pending_payment_id, unique: true
  end
end
