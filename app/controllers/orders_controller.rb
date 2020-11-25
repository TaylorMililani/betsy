class OrdersController < ApplicationController
  before_action :require_login, only: [:show]
  before_action :find_order, except: [:create]

  def show
    if @order.nil?
      flash[:error] = "Invalid Order"
      redirect_back(fallback_location: root_path)
      return
    else
      @order_items = @current_user.order_items.where(order_id:@order.id)
      if @order_items.empty?
        flash[:error] = "You are not authorized to view this! Sneaky!"
        redirect_to products_path
      end
    end
  end

  def create

    @order = Order.new(order_params)
    if @order.save
      flash[:success] = "Successfully created #{@order.id}"
      redirect_to order_path(@order)
      return
    else
      flash[:error] = "Something happened! Please try again!"
      redirect_to root_path
    end
  end

  def edit
    if @order.nil?
      head :not_found
      return
    elsif @order.status != "pending"
      flash[:error] = "We are processing your order. Please call us at 911 if you want to make changes! Thank you!"
      redirect_to root_path
      return
    end
  end

  def update
    if @order.order_items.empty?
      flash[:error] = "There is no item in your cart!"
      redirect_to products_path
    elsif @order.stock_error > 0
        flash[:error] = "Our stock have changed. We have updated your cart to reflect the available quantity."
        redirect_to shopping_cart_path(@order)
        return
    else
      if @order.nil?
        head :not_found
        return
      elsif @order.update(order_params)
        @order.place_order
        flash[:success] = "Your order ##{@order.id} has been placed!"
        redirect_to order_confirmation_path(@order)
        return
      else
        render :edit, status: :bad_request
        return
      end
    end
  end

  def confirmation
    if @order.nil?
      flash[:error] = "Something happened! Please try again!"
      redirect_to products_path
    else
      if session[:order_id] == @order.id
        @order_items = @order.order_items
        session[:order_id] = nil
      else
        flash[:error] = "You are not authorized to view this! Sneaky!"
        redirect_to products_path
      end
    end
  end

  def cancel_order
    if @order.nil?
      flash[:error] = "Something happened! Please try again!"
      redirect_to products_path
    else
      @order.update_attribute(:status, "cancelled" )
      flash[:success] = "Successfully cancelled #{@order.id}"
      redirect_back(fallback_location: manage_orders_path)
    end
  end

  def complete_order
    if @order.nil?
      flash[:error] = "Something happened! Please try again!"
      redirect_to products_path
    else
      @order.update_attribute(:status, "complete" )
      flash[:success] = "Successfully shipped #{@order.id}"
      redirect_back(fallback_location: manage_orders_path)
    end
  end

  private

  def order_params
    return params.require(:order).permit(:id, :name, :email, :address, :cc_num, :cc_expiration, :cvv, :billing_zip, :status, :order_items)
  end

  def find_order
    @order = Order.find_by(id: params[:id])
  end

end
