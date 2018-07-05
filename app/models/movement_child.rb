class MovementChild < ApplicationRecord
  belongs_to :parent, class_name: 'Movement'
  belongs_to :child, class_name: 'Movement'
end
