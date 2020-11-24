class ReviewsController < ApplicationController

  def new
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new
  end

  def create
    product = Product.find_by(id: params[:product_id])
    user_id = product.user_id

    @review = Review.new(
        rating: params[:review][:rating],
        text_field: params[:review][:text_field],
        title: params[:review][:title],
        product_id: params[:product_id]
    )

    if session[:user_id] == user_id
      flash[:error] = "You can't review your own product!"
      redirect_to product_path(product.id)
      return
    end

    if @review.save
      flash[:success] = "Your review was added."
      redirect_to product_path(product.id)
      return
    else
      flash[:error] = "Hmm, something went wrong"
      redirect_to products_path
      return
    end
  end

end
