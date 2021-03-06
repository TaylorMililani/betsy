class CategoriesController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      flash[:error] = "Category does not exist."
      head :not_found
      return
    end
  end

  def new
    @category = Category.new
  end


  def create
    @category = Category.new(category_params)
    @categories = Category.all
    if @category.save
      flash[:success] = "#{@category.name} has been added!"
      redirect_to categories_path
      return
    else
      render :new, status: :bad_request
      return
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
