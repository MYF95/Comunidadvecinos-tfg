class AddIndexUniqueToApartmentLetters < ActiveRecord::Migration[5.2]
  def change
    add_index :apartments, [:floor, :letter], unique: true
  end
end
