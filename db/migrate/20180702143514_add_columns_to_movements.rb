class AddColumnsToMovements < ActiveRecord::Migration[5.2]
  def change
    add_column :movements, :date_value, :date
    add_column :movements, :currency_movement, :string
    add_column :movements, :post_balance, :integer
    add_column :movements, :currency_balance, :string
    add_column :movements, :office, :integer
    add_column :movements, :concept1, :string
    add_column :movements, :concept2, :string
    add_column :movements, :concept3, :string
    add_column :movements, :concept4, :string
    add_column :movements, :concept5, :string
    add_column :movements, :concept6, :string
  end
end
