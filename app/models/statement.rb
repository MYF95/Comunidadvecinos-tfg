class Statement < ApplicationRecord
  # before_destroy :destroy_movements
  before_destroy :destroy_movement_statements
  before_destroy :destroy_bank_statement

  has_many :statement_movements
  has_many :movements, through: :statement_movements
  has_one_attached :bank_statement

  validates :name, presence: true

  private
    # def destroy_movements
    #   unless self.statement_movements.empty?
    #     self.statement_movements.each do |statement_movement|
    #       movement = Movement.find(statement_movement.movement_id)
    #       unless movement.statement_movements.count > 1
    #         movement.destroy
    #       end
    #     end
    #   end
    # end
    #
    # def destroy_movement_statements
    #   unless self.statement_movements.empty?
    #     self.statement_movements.destroy_all
    #   end
    # end

    def destroy_movement_statements
      unless self.movements.empty?
        self.movements.each do |movement|
          StatementMovement.find_by(statement: self, movement: movement).destroy
          unless movement.statements.count > 0
            movement.destroy
          end
        end
      end
    end

    def destroy_bank_statement
      self.bank_statement.purge
    end
end
