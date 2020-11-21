class ReviewsController < ApplicationController
  # def index
  #   @reviews = Review.all #.find_by(id: product_id) ??
  # end

  def create
    @review = Review.new(review_params)
    user_id = Product.find_by(id: params[:id]).id
    if session[:user_id] == user_id
      flash.now[:error] = "You can't review your own product!"
    elsif @review.save
      flash[:success] = "Thanks for your feedback!"
    else
      flash.now[:error] = "Hmm..something went wrong, your review was not saved"
    end
    redirect_to root_path # ??
  end

  private
  def review_params
    return params(:review).permit(:title, :rating, :text_field)
  end
end
