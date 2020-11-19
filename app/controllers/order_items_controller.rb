class OrderItemsController < ApplicationController

  def index
    @order_items = OrderItem.all.find_by(id: order_id) # find by order id?
  end

  def show
    @order_item = OrderItem.find_by(product_id: params[:id],order_id: params[:id]) # ??
    if @order_item.nil?
      flash.now[:error] = "Hmm, we couldn't find an order item with that order id and product id"
      redirect_to root_path # for now?
    end
  end

  def create
    @order_item = OrderItem.new(product_id: params[:id], order_id: params[:id])
    if @order_item.save
      flash[:success] = "Item successfully added to order"
      redirect_to order_path(order_id: params[:id])
    else
      flash.now[:error] = "hmm..something went wrong"
      redirect_to root_path
    end
  end

  # def destroy ??
  #
  # end
end
