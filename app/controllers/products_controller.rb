class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def homepage
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      head :not_found
      return
    end
  end

  def new
    @product = Product.new
  end

  def create
    #create a new product
    @product = Product.new(product_params)

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
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      head :not_found
      return
    end
  end

  def update
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      head :not_found
      return
    elsif @product.update(product_params)
      flash[:success] = "#{@product.name} updated successfully"
      redirect_to products_path # go to the list of products
      return
    else # save failed :(
    flash.now[:error] = "Something happened. #{@product.name} not updated."
    render :edit, status: :bad_request # show the new product form view again
    return
    end
  end

  def destroy
    product_id = params[:id]
    @product = Product.find_by(id: product_id)

    if @product.nil?
      head :not_found
      return
    end

    @product.destroy

    redirect_to products_path
    return
  end



  private
  def product_params
    params.require(:product).permit(:name, :description, :category, :price, :in_stock, :photo)
  end

end
