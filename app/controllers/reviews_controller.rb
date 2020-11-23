class ReviewsController < ApplicationController
  # def index
  #   @reviews = Review.all #.find_by(id: product_id) ??
  # end
  #
  def new
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new #(:title, :rating, :text_field)
    user_id = User.find_by(id: @product[:user_id])
    if session[:user_id] == user_id
      flash.now[:error] = "You can't review your own product!"
      redirect_to root_path
      return
    end

    if @review.save
      flash[:success] = "Thanks for your feedback!"
    else
      flash.now[:error] = "Hmm..something went wrong, your review was not saved"
    end
    redirect_to product_path(@product.id) # ??
    return
  end

  # private
  # def review_params
  #   return params(:review).permit(:title, :rating, :text_field)
  # end
end
