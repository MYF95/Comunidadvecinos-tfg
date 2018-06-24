class RenameTransactionToMovement < ActiveRecord::Migration[5.2]
  def change
    rename_table :transactions, :movements
  end
end
