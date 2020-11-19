class ReviewsController < ApplicationController
  # def index
  #   @reviews = Review.all #.find_by(id: product_id) ??
  # end
  #
  # def show
  #   @review = Review.find_by(id: params[id])
  #   if @review.nil?
  #     flash[:error] = "Hmm..we couldn't find a review with that id"
  #     redirect_to root_path #for now
  #   end
  # end

  # def new
  #   @review = Review.new
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

  # def destroy
  #   @review = Review.find_by(id: params[:id])
  #   if @review.nil?
  #     flash.now[:error] = "Hmm..we couldn't find a review with that id"
  #     redirect_to root_path # for now
  #     return
  #   else
  #     @review.destroy
  #     flash[:success] = "You've successfully deleted this review! Who needs it!"
  #     redirect_to root_path
  #     return
  #   end
  # end
  private
  def review_params
    return params(:review).permit(:title, :rating, :text_field)
  end
end
