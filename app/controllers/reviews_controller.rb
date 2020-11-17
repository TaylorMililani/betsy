class ReviewsController < ApplicationController
  def index
    @reviews = Review.all #.find_by(id: product_id) ??
  end

  def show
    @review = Review.find_by(id: params[id])
    if @review.nil?
      flash[:error] = "Hmm..we couldn't find a review with that id"
      redirect_to root_path #for now
    end
  end

  def new
    @review = Review.new
  end

  def create
    # add elsif to make sure merchant isnt reviewing their own product?
    @review = Review.new(review_params)
    if @review.save
      flash[:success] = "Thanks for your feedback!!"
      redirect_to review_path(id: @review[:id])
      return
    else
      flash.now[:error] = "Hmm..something went wrong, your review was not saved"
      render :new, status: :bad_request
      return
    end
  end

  def destroy
    @review = Review.find_by(id: params[:id])
    if @review.nil?
      flash.now[:error] = "Hmm..we couldn't find a review with that id"
      redirect_to root_path # for now
      return
    else
      @review.destroy
      flash[:success] = "You've successfully deleted this review! Who needs it!"
      redirect_to root_path
      return
    end
  end

  def review_params
    return params(:review).permit(:rating, :text_field)
  end
end
