class ReviewsController < ApplicationController
  # def index
  #   @product = Product.find_by(id: params[:product_id])
  #   @reviews = Review.where(id: @product.id)
  # end

  def new
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new
  end

  def create
    @review = Review.new(
        title: params[:title],
        rating: params[:rating],
        text_field: params[:text_field],
        product_id: params[:product_id]
    )

    user_id = Product.find_by(id: params[:product_id]).user_id

    if session[:user_id] == user_id
      flash.now[:error] = "You can't review your own product!"
    elsif @review.save && (session[:user_id] != merchant_id)
      flash[:success] = "Your review was added."
    else
      flash[:failure] = "Error: Review could not be added."
    end
    redirect_to
    return
  end

  # private

  # def review_params
  #   return params.require(:review).permit(:title, :rating, :text_field, :product_id)
  # end

end
