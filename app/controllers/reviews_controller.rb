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

    product = Product.find_by(id: params[:product_id])
    user_id = product[:user_id]

    @review = Review.new(
        rating: params[:rating],
        text_field: params[:text_field],
        title: params[:title],
        product_id: params[:product_id]
    )

    unless session[:user_id] == nil
      if session[:user_id] == user_id
        flash.now[:error] = "You can't review your own product!"
        redirect_back(fallback_location: :back)
        return
      end
    end

    if @review.save
      flash[:success] = "Your review was added."
    else
      flash[:error] = "Hmm, something went wrong"
      redirect_back(fallback_location: :back)
      return
    end

    redirect_to product_path(product.id)
    return
  end

  private

  # def review_params
  #   params.require(:reviews).permit(:rating, :text_field, :title, :product_id)
  # end

end
