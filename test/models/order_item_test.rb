require "test_helper"

describe OrderItem do
  before do
    @user = User.create(username: "test", email: "test@test.com")
    @product = Product.create(name: "product", description: "test product", price: 10, in_stock: 2, user_id: @user.id)
    @order = Order.create!
    @order_item = OrderItem.create(name: @product.name, price: @product.price, quantity: 1, product_id: @product.id, order_id: @order.id)
  end

  it "can be instantiated" do
    expect(@order_item.valid?).must_equal true
  end

  describe "Relationships" do
    it "belongs to a product" do
      expect(@order_item.product).must_be_instance_of Product
      expect(@order_item.order).must_be_instance_of Order
    end
  end

  describe "Validations" do
    it "wont create new orderitem if there is no quantity" do
      order_item = OrderItem.create(name: @product.name, price: @product.price, quantity: nil, product_id: @product.id, order_id: @order.id)

      expect(order_item.valid?).must_equal false
    end

    it "wont create a new orderitem with invalid product id" do
      order_item = OrderItem.create(name: @product.name, price: @product.price, quantity: 1, product_id: -1, order_id: @order.id)

      expect(order_item.valid?).must_equal false
    end

    it "wont create a new orderitem with invalid order id" do
      order_item = OrderItem.create(name: @product.name, price: @product.price, quantity: 1, product_id: @product.id, order_id: -1)

      expect(order_item.valid?).must_equal false
    end
  end
end
