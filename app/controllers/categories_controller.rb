class CategoriesController < ApplicationController

  def index
    @category = Category.all
  end

  def show
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      flash[:error] = "Category does not exist."
      head :not_found
      return
    end
    @products = @category.products
  end

  def new
    @categories = Category.all
    @category = Category.new
  end


  def create
    @category = Category.new(category_params)
    @categories = Category.all
    if @category.save
      flash[:success] = "#{@category.name} has been added!"
      redirect_to current_user_path
      return
    else
      flash.now[:error] = "Something went wrong. #{@category.errors.messages[:name]}"
      render :new
      return
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
