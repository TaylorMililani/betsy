class OrderItemsController < ApplicationController

  def shopping_cart
    @order = Order.find_by(id: session[:order_id])
    if @order.nil? == false
      @order_items = OrderItem.where(order_id: @order.id)
    end
  end

  def create
    product = Product.find_by(id: params[:product_id])

    if product.in_stock == 0
      flash[:error] = "I'm sorry, that product is out of stock!"
      redirect_to products_path
      return
    end

    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
    elsif session[:order_id].nil?
      @new_order = Order.create
      session[:order_id] = @new_order.id
    else
      flash[:error] = "hmm..something went wrong"
      redirect_to products_path
    end

    @order_item = OrderItem.create!(name: product.name, price: product.price, quantity: params[:quantity], product_id: product.id, order_id: session[:order_id], user_id: product.user.id)
    redirect_to shopping_cart_path
  end

  def update
    @order_item = OrderItem.find_by(id: params[:id])
    if @order_item.nil?
      flash[:error] = "hmm, we couldn't find a product in your cart with that id"
    else
      @order_item.update(quantity: params[:quantity])
    end
    redirect_to shopping_cart_path
  end

  def destroy
    @order_item = OrderItem.find_by(id: params[:id])
    if @order_item.quantity == 0
      @order_item.destroy
      redirect_to shopping_cart_path
      return
    end
    if @order_item.nil?
      flash[:error] = "hmm, we couldn't find a product in your cart with that id"
      redirect_to shopping_cart_path
      return
    else
      @order_item.destroy
      flash[:success] = "Item removed from cart"
      redirect_to shopping_cart_path
      return
    end
  end

end