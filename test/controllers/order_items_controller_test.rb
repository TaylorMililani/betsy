require "test_helper"

describe OrderItemsController do
  describe "shopping cart" do
    it "can get the shopping cart page" do
      # @product = Product.create(name: "product", description: "test product", price: 10, in_stock: 2)
      @order = Order.create!(id: 1)
      get shopping_cart_path(order_id: @order.id)

      must_respond_with :success
    end
  end

  describe "create" do
    it "can be created" do
      @product = Product.create(id: 1, name: "product", description: "test product", price: 10, in_stock: 2)
      @order = Order.create(id: 1)
      order_item_hash ={
          order_item: {
              name: @product[:name],
              price: @product[:price],
              quantity: 1,
              product_id: @product[:id],
              order_id: @order[:id]
          }
      }
      expect{
        post order_items_path, params: order_item_hash
      }.must_differ "OrderItem.count", 1
    end
  end

  describe "update" do

  end

  describe "destroy" do

  end
end
