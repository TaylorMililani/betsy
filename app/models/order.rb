class Order < ApplicationRecord
  has_many :order_items

  validates :name, presence: true, on: :update
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid Format"  },
            length: { minimum: 4, maximum: 254 },
            on: :update
  validates :address, presence: true, on: :update
  validates :cc_num, presence: true, length: { minimum: 12 }, on: :update
  # validate :valid_card_number?, on: :update
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

  def stock_error
    order_items = self.order_items
    out_of_stock = 0
    order_items.each do |order_item|
      if order_item.quantity > order_item.product.in_stock
        if order_item.product.in_stock == 0
          order_item.destroy
        else
          order_item.quantity = order_item.product.in_stock
          order_item.save
        end
        out_of_stock += 1
      end
    end

    return out_of_stock
  end

  def place_order
    self.update_attribute(:status, "paid" )
    self.order_items.each do |item|
      if item.product.in_stock >= item.quantity
        item.product.in_stock -= item.quantity
      else
        flash[:error] = "Not enough stock available for purchase. Current stock for : #{item.product.in_stock} "
        redirect_to products_path
      end
      item.product.save!
    end
  end


  def total_cost
    total = 0
    self.order_items.each do |item|
        total += item.subtotal
    end
    return total
  end



end