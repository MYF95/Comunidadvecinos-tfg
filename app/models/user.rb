class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super
    end
  end

  before_destroy :destroy_user_apartments
  before_destroy :destroy_owned_apartments

  has_many :user_apartments
  has_many :apartments, through: :user_apartments

  has_many :apartment_owners
  has_many :owned_apartments, through: :apartment_owners

  private

    def destroy_user_apartments
      unless self.apartments.empty?
        self.user_apartments.destroy_all
      end
    end

    def destroy_owned_apartments
      unless self.owned_apartments.empty?
        self.apartment_owners.destroy_all
      end
    end
end
