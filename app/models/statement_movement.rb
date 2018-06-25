class StatementMovement < ApplicationRecord
  belongs_to :statement
  belongs_to :movement

  validates :statement_id, :uniqueness => {:scope => :movement_id, :message => 'el extracto bancario no puede tener movimientos duplicados'}

end
