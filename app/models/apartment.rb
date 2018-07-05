class Apartment < ApplicationRecord
  #TODO en caso de que la planta sea 0, que se ponga como BajoºA

  before_destroy :destroy_apartment_movements
  before_destroy :destroy_apartment_pending_payments
  before_destroy :destroy_apartment_owners
  before_destroy :destroy_apartment_users

  before_save :uppercase_letter

  has_many :user_apartments
  has_many :users, through: :user_apartments

  has_many :apartment_movements
  has_many :movements, through: :apartment_movements

  has_many :apartment_pending_payments
  has_many :pending_payments, through: :apartment_pending_payments, dependent: :destroy

  has_one :apartment_owner
  has_one :owner, through: :apartment_owner

  validates :floor, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}, uniqueness: {scope: :letter}
  validates :letter, presence: true
  validates :fee, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates_inclusion_of :apartment_contribution, :in => 0..1

  private

    def destroy_apartment_movements
      unless self.movements.blank?
        self.apartment_movements.destroy_all
      end
    end

    def destroy_apartment_pending_payments
      unless self.pending_payments.blank?
        self.apartment_pending_payments.destroy_all
      end
    end

    def destroy_apartment_owners
      unless self.owner.nil?
        self.apartment_owner.destroy
      end
    end

    def destroy_apartment_users
      unless self.users.empty?
        self.user_apartments.destroy_all
      end
    end

    def uppercase_letter
      self.letter.upcase!
    end
end
