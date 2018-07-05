class Movement < ApplicationRecord
  #TODO seed with correct params movement
  before_destroy :destroy_apartment_movements

  has_many :statement_movements
  has_many :statements, through: :statement_movements

  has_one :apartment_movement
  has_one :apartment, through: :apartment_movement

  has_one :parent, class_name: 'MovementChild', foreign_key: 'child_id'
  has_many :children, class_name: 'MovementChild', foreign_key: 'parent_id'

  validates :concept, presence: true
  validates :date, presence: true
  validates :amount, presence: true

  private

    def destroy_apartment_movements
      unless self.apartment.nil?
        self.apartment_movement.destroy
      end
    end

    def destroy_statement_movements
      unless self.statements.empty?
        self.statements.each do |statement|
          StatementMovement.find_by(statement: statement, movement: self).destroy
        end
      end
    end
end
