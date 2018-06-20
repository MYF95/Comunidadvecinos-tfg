class CreateApartments < ActiveRecord::Migration[5.2]
  def change
    create_table :apartments do |t|
      t.string :owner
      t.integer :floor
      t.string :letter
      t.integer :fee
      t.integer :balance

      t.timestamps
    end
  end
end
