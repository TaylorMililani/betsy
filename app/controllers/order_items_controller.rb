class OrderItemsController < ApplicationController

  def index
    @order_items = OrderItem.all  #.find_by(id: order_id) # find by order id?
  end

  def create
    @order_item = OrderItem.new(product_id: params[:id], order_id: params[:id])
    if session[:order_id]
      @order = Order.find_by(id: :order_id)
    elsif session[:order_id].nil?
      @new_order = Order.create
    else
      flash.now[:error] = "hmm..something went wrong"
    end
    redirect_to root_path
  end

  def update

  end

  def destroy ??

  end

  private

  def order_item_params
    return params(:order_item).permit(:name, :price, :quantity, :order_id, :product_id)
  end
end
