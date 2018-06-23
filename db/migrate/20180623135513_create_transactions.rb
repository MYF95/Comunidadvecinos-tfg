class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.text :concept
      t.date :date
      t.integer :amount
      t.text :description

      t.timestamps
    end
  end
end
