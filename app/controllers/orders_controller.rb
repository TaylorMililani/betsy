class OrdersController < ApplicationController
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
    end
  end

  def update
    if @order.nil?
      head :not_found
      return
    elsif @order.update(order_params)
      flash[:success] = "Successfully updated #{@order.id}"
      redirect_to orders_path
      return
    else
      render :edit, status: :bad_request
      return
    end
  end

  # def destroy
  #   if @order.nil?
  #     head :not_found
  #     return
  #   end
  #
  #   @order.destroy
  #   flash[:success] = "Successfully destroyed #{@order.id}"
  #   redirect_to orders_path
  #   return
  # end

  private

  # def order_params
  #   return params.require(:order).permit(:email, :address, :name, :cc_num, :cc_expiration, :cvv, :zip_code)
  # end

  def find_order
    @order = Order.find_by(id: params[:id])
  end

end