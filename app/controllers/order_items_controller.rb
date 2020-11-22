class OrderItemsController < ApplicationController

  def shopping_cart
    order = Order.find_by(id: session[:order_id])
    @order_items = OrderItem.where(order_id: order.id)
  end

  def create
    product = Product.find_by(id: params[:product_id])

    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
    elsif session[:order_id].nil?
      @new_order = Order.create
      session[:order_id] = @new_order.id
      # @order_item.order_id = @new_order.id
    else
      flash.now[:error] = "hmm..something went wrong"
    end
    @order_item = OrderItem.create!(name: product.name, price: product.price, quantity: params[:quantity], product_id: params[:product_id], order_id: session[:order_id])
    redirect_to shopping_cart_path
    # make  sure there's enough inventory??
  end

  def update
    #upda
  end

  def destroy
    if @order_item.nil?
      flash.now[:error] = "Hmm, we couldn't find an order item with that id"
    else
      @order_item.destroy
      # add back to product inventory
    end
    redirect_to root_path #for now
  end

  private

  # def order_item_params
  #   return params.require(:order_item).permit(:name, :price, :quantity, :order_id, :product_id)
  # end
end
