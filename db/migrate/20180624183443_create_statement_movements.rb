class CreateStatementMovements < ActiveRecord::Migration[5.2]
  def change
    create_table :statement_movements do |t|
      t.integer :statement_id
      t.integer :movement_id

      t.timestamps
    end
  end
end
