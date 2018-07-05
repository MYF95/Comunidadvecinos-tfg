class ApartmentOwner < ApplicationRecord
  belongs_to :owned_apartment, class_name: 'Apartment', foreign_key: 'apartment_id'
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'

end
