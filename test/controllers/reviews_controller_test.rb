require "test_helper"

describe ReviewsController do
  describe "New" do
    it "gets the new review page" do
      @product = Product.create(id: 1, name: "product", description: "test product", price: 10, in_stock: 2)

      get new_product_review_path(product_id: @product.id)

      must_respond_with :success
    end
  end

  describe "Create" do

  end
end
