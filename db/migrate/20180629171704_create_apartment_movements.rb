class CreateApartmentMovements < ActiveRecord::Migration[5.2]
  def change
    create_table :apartment_movements do |t|
      t.integer :apartment_id
      t.integer :movement_id

      t.timestamps
    end
    add_index :apartment_movements, :movement_id, unique: true
  end
end
