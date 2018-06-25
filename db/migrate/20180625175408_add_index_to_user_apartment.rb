class AddIndexToUserApartment < ActiveRecord::Migration[5.2]
  def change
    add_index :user_apartments, [:user_id, :apartment_id], unique: true
  end
end
