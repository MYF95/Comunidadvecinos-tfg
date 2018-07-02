class ChangeMovementAmountToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :movements, :amount, :float
    change_column :movements, :post_balance, :float
  end
end
