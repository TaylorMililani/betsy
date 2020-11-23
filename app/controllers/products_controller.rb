class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update, :destroy]
  # before_action :only_see_own_page, only: [:create, :edit, :update, :destroy]
  before_action :require_ownership, only: [:edit, :update, :destroy]


  def index
    @products = Product.all
  end

  def homepage
    @products = Product.all
  end

  def show
    if @product.nil?
      head :not_found
      return
    end
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    #create a new product
    @product = Product.new(product_params)
    @product.user = @current_user

    if params[:product][:photo].nil?
      @product.photo = "/soul_dummy.jpeg"
    else
      @product.photo = upload_photo(params[:product][:photo])
    end

    @categories = Category.all


    if @product.save
      flash[:success] = "#{@product.name} was successfully created!"
      redirect_to product_path @product.id
      return
    else
      flash.now[:error] = "#{@product.name} was NOT added"
      render :new, status: :bad_request
      return
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    @categories = Category.all

    if params[:product][:photo]
      @product.photo = upload_photo(params[:product][:photo])
    end

    if @product.update(product_params)
      flash[:success] = "#{@product.name} updated successfully"
      redirect_to product_path(@product) # go to the list of products
      return
    else # save failed :(
    flash.now[:error] = "Something happened. #{@product.name} not updated."
    render :edit, status: :bad_request # show the new product form view again
    return
    end
  end

  def destroy
    if !@product.order_items.empty?
      
      flash[:error] = "Product cannot be deleted, because it's a part of an order."
      redirect_to product_path(@product)
      return
    else
      @product.destroy
      redirect_to products_path
      return
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :description, :category, :price, :in_stock, category_ids:[])
  end

  def require_ownership
    @product = Product.find_by(id: params[:id])
    if @product && @product.user!= @current_user
      flash[:error] = "You can't modify a product that you don't own"
      redirect_to product_path(@product)
    end
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:error] = "Product not found."
      redirect_to products_path, status: :not_found
      return
    end
  end

  def upload_photo(uploaded_file)
    File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end
    return "/uploads/#{uploaded_file.original_filename}"
  end
end
