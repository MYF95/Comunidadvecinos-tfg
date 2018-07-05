class CreateMovementChildren < ActiveRecord::Migration[5.2]
  def change
    create_table :movement_children do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end
    add_index :movement_children, :child_id, unique: true
  end
end
