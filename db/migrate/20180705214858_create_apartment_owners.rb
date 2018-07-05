class CreateApartmentOwners < ActiveRecord::Migration[5.2]
  def change
    create_table :apartment_owners do |t|
      t.integer :apartment_id
      t.integer :user_id

      t.timestamps
    end
    add_index :apartment_owners, :apartment_id, unique: true
  end
end
