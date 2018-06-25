class CreateUserApartments < ActiveRecord::Migration[5.2]
  def change
    create_table :user_apartments do |t|
      t.integer :user_id
      t.integer :apartment_id

      t.timestamps
    end
  end
end
