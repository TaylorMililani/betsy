class OrdersController < ApplicationController

  before_action :find_order, only: [:show, :edit, :update, :destroy]


  def index
    @orders = Order.all
  end

  def show
    if @order.nil?
      head :not_found
      return
    end
  end

  def new
    @order = Order.new
  end

  def create

    @order = Order.new(order_params)
    if @order.save
      flash[:success] = "Successfully created #{@order.id}"
      redirect_to order_path(@order)
      return
    else
      render :new, status: :bad_request
      return
    end
  end

  def edit
    if @order.nil?
      head :not_found
      return
    elsif @order.status != "pending"
      flash[:error] = "We are processing your order. Please call us at 911 if you want to make changes! Thank you!"
      redirect_to order_path(@order)
    end
  end

  def update
    if @order.order_items.empty?
      flash[:error] = "There is no item in your cart!"
      redirect_to products_path
    else
      if @order.nil?
        head :not_found
        return
      elsif @order.update(order_params)
        @order.place_order
        session[:order_id] = nil
        flash[:success] = "Your order ##{@order.id} has been placed!"
        redirect_to order_path(@order)
        return
      else
        flash[:error] = "Something went wrong!"
        redirect_to products_path
        return
      end

    end


  end

  def destroy
    if @order.nil?
      head :not_found
      return
    end

    @order.destroy
    flash[:success] = "Successfully destroyed #{@order.id}"
    redirect_to orders_path
    return
  end

  private

  def order_params
    return params.require(:order).permit(:name, :email, :address, :cc_num, :cc_expiration, :cvv, :billing_zip, :status, :order_items)
  end

  def find_order
    @order = Order.find_by(id: params[:id])
  end

end
