class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  belongs_to :user
  validates :quantity, presence: true, numericality: { greater_than: 0 }


  # def cart_total
  #   total = 0.0
  #   @order_items.each do |orderitem|
  #     total += orderitem.price
  #   end
  #   return total
  # end
  #

  def subtotal
    return self.quantity * self.price
  end

  def self.filter_user_status(user: nil, status: nil)
    return [] if user.nil?
    items = []
    if status
       OrderItem.where(user_id: user.id).each do |item|
         items << item if item.order.status == status
       end
    else
      items = OrderItem.where(user_id: user.id)
    end
    return items
  end

end

