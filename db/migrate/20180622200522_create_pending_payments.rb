class CreatePendingPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :pending_payments do |t|
      t.text :concept
      t.date :date
      t.integer :amount
      t.text :description
      t.boolean :paid

      t.timestamps
    end
  end
end
