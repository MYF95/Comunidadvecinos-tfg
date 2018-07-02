class Statement < ApplicationRecord
  before_destroy :destroy_movements

  has_many :statement_movements
  has_many :movements, through: :statement_movements
  has_one_attached :bank_statement

  validates :name, presence: true
  validates :date, presence: true

  private
    def destroy_movements
      unless self.movements.empty?
        self.movements.each do |movement|
          StatementMovement.find_by(statement: self, movement: movement).destroy
          unless movement.statements.count > 0
            movement.destroy
          end
        end
      end
    end
end
