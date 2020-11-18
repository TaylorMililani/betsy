class Order < ApplicationRecord
  validates :name, presence: true
  validates :email,
            format: { with: /^(.+)@(.+)$/, message: "Email invalid"  },
            length: { minimum: 4, maximum: 254 }
  validates :address, presence: true
  validates :cc_num, presence: true, numericality: true
  validates :ccv, presence: true, length: { in: 3..4 }
  validates :cc_expiration, presence: true
  validates :billing_zip, presence: true, length: { is: 5 }, numericality: true
end
