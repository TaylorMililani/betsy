class Review < ApplicationRecord
  belongs_to :product

  validates :rating, presence: true, :inclusion => { :in => [1,2,3,4,5] }
end

# resources :review, except [:edit, :update]

# validates :merchant_id { scope: product_id if product belongs_to :merchant } ??? merchants cant review their own products