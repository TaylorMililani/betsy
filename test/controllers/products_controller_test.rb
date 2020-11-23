require "test_helper"

describe ProductsController do

  describe "index" do
    it "must get index" do
      get products_path
      must_respond_with :success
    end
  end

  describe "new" do
    it "can get a new product path" do
      get new_product_path
      must_respond_with :success
    end
  end

  describe "create" do

    let (:user2) {
      users(:user2)
    }

    let (:product_hash) {
      {
          product: {
              name: "Wonder woman",
              description: "powerful, strong-willed character",
              price: 3000,
              in_stock: 10,
              user_id: user2.id
          }
      }
    }

    it "can create a product" do
      perform_login(user2)
      logged_in_user = User.find_by(id: session[:user_id])

      expect {
        post products_path, params: product_hash
      }.must_differ 'Product.count', 1

      created_product = Product.last
      must_respond_with  :redirect
      must_redirect_to product_path(created_product.id)
      expect(created_product.name).must_equal product_hash[:product][:name]
      expect(created_product.description).must_equal product_hash[:product][:description]
      expect(created_product.user).must_equal logged_in_user
    end



  end


end
