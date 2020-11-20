class Order < ApplicationRecord
  validates :name, presence: true, on: :update
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid Format"  },
            length: { minimum: 4, maximum: 254 },
            on: :update
  validates :address, presence: true, on: :update
  validates :cc_num, presence: true, length: { minimum: 12 }, on: :update
  validate :valid_card_number?, on: :update
  validates :cvv, presence: true, length: { in: 3..4 }, on: :update
  validates :cc_expiration, presence: true, on: :update
  validates :billing_zip, presence: true, on: :update



def valid_card_number?
  cc_number = self.cc_num
  cc_number.gsub!(/\s+/, "")
  num = cc_number.reverse.each_char.with_index.map do |char, index|
    char = char.to_i
    if index.odd?
      char > 4 ? (char * 2 - 9) : char * 2
    else
      char
    end
  end
  unless num.sum % 10 == 0
    errors.add(:cc_num, 'Invalid Credit Card Number ')
  end
end




end