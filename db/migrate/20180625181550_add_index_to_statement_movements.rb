class AddIndexToStatementMovements < ActiveRecord::Migration[5.2]
  def change
    add_index :statement_movements, [:statement_id, :movement_id], unique: true
  end
end
