require "test_helper"

describe OrderItemsController do
  before do
    @user = User.create(username: "test", email: "test@test.com")
    @product = Product.create(name: "product", description: "test product", price: 10, in_stock: 2, user_id: @user.id)
    @order = Order.create!
    @order_item_hash = {
        name: @product.name,
        price: @product.price,
        quantity: 1,
        product_id: @product.id,
        order_id: @order.id
    }
    @new_order_item = OrderItem.create(name: @product.name, price: @product.price, quantity: 1, product_id: @product.id, order_id: @order.id)
  end
  describe "shopping cart" do
    it "can get the shopping cart page" do
      get shopping_cart_path(order_id: @order.id)

      must_respond_with :success
    end
  end

  describe "create" do
    it "can be created" do
      expect {
        post order_items_path, params: @order_item_hash
      }.must_differ "OrderItem.count", 1
    end

    it "wont be created if product is out of stock" do
      product = Product.create(name: "product2", description: "test product2", price: 10, in_stock: 0, user_id: @user.id)

      order_item_hash = {
          name: product.name,
          price: product.price,
          quantity: 1,
          product_id: product.id,
          order_id: @order.id
      }

      expect {
        post order_items_path, params: order_item_hash
      }.wont_change "OrderItem.count"
    end
  end

  describe "update" do
    it "can update quantity" do

      edit_params = {
          order_item: {
              quantity: 2
          }
      }

      expect {
        patch order_item_path(@new_order_item.id), params: edit_params
      }.wont_change "OrderItem.count"

    end
  end

  describe "destroy" do
    it "can remove order item from cart" do
      expect{
        delete order_item_path(@new_order_item.id)
      }.must_change "OrderItem.count", -1
    end
  end
end
