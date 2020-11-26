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

    it "will not create a book with invalid parameters" do
      product_hash[:product][:name] = nil

      expect {
        post products_path, params: product_hash
      }.must_differ "Product.count", 0

      must_respond_with :bad_request
    end

  end

  describe "update" do

    let (:user2) {
      users(:user2)
    }

    let (:new_product_hash) {
      {
        product: {
          name: "Sting",
          description: "singer",
          price: 123,
          in_stock: 5,
          user_id: user2.id
        }
      }
    }
    it "will update model with a valid post request" do
      perform_login(user2)

      product = Product.find_by_name("Frida Kahlo")
      id = product.id
      expect {
        patch product_path(id), params: new_product_hash
      }.wont_change "Product.count"

      must_respond_with :redirect

      product.reload
      expect(product.name).must_equal new_product_hash[:product][:name]
      expect(product.description).must_equal new_product_hash[:product][:description]
      expect(product.user_id).must_equal new_product_hash[:product][:user_id]
    end

    it "will respond with bad request for invalid ids" do
      id = -1

      expect {
        patch product_path(id), params: new_product_hash
      }.wont_change "Product.count"

      must_respond_with :not_found
    end

    it "will not update if the params are invalid" do
      perform_login(user2)
      new_product_hash[:product][:name] = nil
      product = Product.find_by_name("Frida Kahlo")

      expect {
        patch product_path(product.id), params: new_product_hash
      }.wont_change "Product.count"

        product.reload
        must_respond_with :bad_request
        expect(product.name).wont_be_nil
    end
  end

  describe "destroy" do
    let (:user2) {
      users(:user2)
    }

    let (:new_product_hash) {
      {
          product: {
              name: "Sting",
              description: "singer",
              price: 123,
              in_stock: 5,
              user_id: user2.id
          }
      }
    }
    it "will destroy a product that doesn't belong to the order_item" do

      #arrange
      perform_login(user2)
      product = products(:product2)
      # act + assert

      expect {
        delete product_path(product.id)
      }.must_change "Product.count", -1

      product.destroy
      must_respond_with :redirect
      must_redirect_to user_path(user2.id)

    end
  end

  describe "retire" do
    let (:user2) {
      users(:user2)
    }

    let (:new_product_hash) {
      {
          product: {
              name: "Sting",
              description: "singer",
              price: 123,
              in_stock: 5,
              user_id: user2.id
          }
      }
    }
    it "set product in stock for the order to 0" do
      perform_login(user2)
      product = products(:product2)
      post retire_path(product.id)
      expect(product.reload.in_stock).must_equal 0

      must_redirect_to user_path(user2.id)
    end

    it "won't change the product in stock if its in order" do
    end
  end

end
