class OrderItemsController < ApplicationController

  def shopping_cart
    @order = Order.find_by(id: session[:order_id])
    @order_items = OrderItem.where(order_id: @order.id)
  end

  def create
    product = Product.find_by(id: params[:product_id])

    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
    elsif session[:order_id].nil?
      @new_order = Order.create
      session[:order_id] = @new_order.id
    else
      flash.now[:error] = "hmm..something went wrong"
    end

    @order_item = OrderItem.create!(name: product.name, price: product.price, quantity: params[:quantity], product_id: params[:product_id], order_id: session[:order_id], user: product.user )
    redirect_to shopping_cart_path
  end

  def update
    @order_item = OrderItem.find_by(id: params[:id])
    if @order_item.nil?
      flash.now[:error] = "hmm, we couldn't find a product in your cart with that id"
    else
      @order_item.update(quantity: params[:quantity])
    end
    redirect_to shopping_cart_path
  end

  def destroy
    @order_item = OrderItem.find_by(id: params[:id])
    if @order_item.quantity == 0
      @order_item.destroy
      redirect_back(fallback_location: :back)
      return
    end
    if @order_item.nil?
      flash.now[:error] = "hmm, we couldn't find a product in your cart with that id"
      redirect_back(fallback_location: :back)
      return
    else
      @order_item.destroy
      flash[:success] = "Item removed from cart"
      redirect_back(fallback_location: :back)
      return
    end
  end

end