class CreateStatements < ActiveRecord::Migration[5.2]
  def change
    create_table :statements do |t|
      t.text :name
      t.date :date

      t.timestamps
    end
  end
end
