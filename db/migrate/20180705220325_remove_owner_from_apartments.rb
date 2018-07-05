class RemoveOwnerFromApartments < ActiveRecord::Migration[5.2]
  def change
    remove_column :apartments, :owner, :string
  end
end
