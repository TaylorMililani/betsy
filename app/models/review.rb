class Review < ApplicationRecord
  belongs_to :product

  # validates :rating, presence: true, :inclusion => { :in => [1,2,3,4,5] }
  # validates :product_id, presence: true
end

# resources :review, except [:edit, :update]