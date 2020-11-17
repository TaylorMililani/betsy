class Order < ApplicationRecord
  validates :email,
            format: { with: /^(.+)@(.+)$/, message: "Email invalid"  },
            length: { minimum: 4, maximum: 254 }
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
end
