class AddMovementDigestToMovements < ActiveRecord::Migration[5.2]
  def change
    add_column :movements, :movement_digest, :string
  end
end
