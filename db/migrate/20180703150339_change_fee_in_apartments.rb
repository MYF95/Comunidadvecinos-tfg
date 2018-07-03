class ChangeFeeInApartments < ActiveRecord::Migration[5.2]
  def change
    change_column :apartments, :fee, :float
    change_column :apartments, :balance, :float
    add_column :apartments, :apartment_contribution, :float
  end
end
