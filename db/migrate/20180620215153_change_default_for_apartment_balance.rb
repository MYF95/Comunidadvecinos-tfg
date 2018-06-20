class ChangeDefaultForApartmentBalance < ActiveRecord::Migration[5.2]
  def change
    change_column :apartments, :balance, :integer, :default => 0
  end
end
