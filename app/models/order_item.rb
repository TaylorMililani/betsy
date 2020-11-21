class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  # def cart_total
  #   total = 0.0
  #   @order_items.each do |orderitem|
  #     total += orderitem.price
  #   end
  #   return total
  # end
end
