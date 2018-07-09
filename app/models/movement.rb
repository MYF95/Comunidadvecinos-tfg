class Movement < ApplicationRecord
  before_destroy :destroy_apartment_movements
  before_destroy :destroy_movement_children
  before_destroy :destroy_statement_movements

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
      unless self.statement_movements.empty?
        self.statement_movements.destroy_all
      end
    end

    def destroy_movement_children
      unless self.children.empty?
        self.children.each do |child|
          Movement.find(child.child_id).destroy
        end
        self.children.destroy_all
      end

      unless self.parent.nil?
        self.parent.destroy
      end
    end
end
