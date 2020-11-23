require "test_helper"

describe OrdersController do
  describe "index" do
    it "can get index page" do
      get orders_path

      must_respond_with :ok
    end
  end

  describe "create " do

    it "can create a new order" do
      order_hash = {
          order: {
              name: "name",
          },
      }
      expect { post orders_path, params: order_hash }.must_differ "Order.count", 1
      order = Order.last
      expect(order).must_be_instance_of Order
    end

  end

  describe "edit" do
    it "responds with success for valid product" do
      # Act
      get edit_order_path(orders(:order1))

      # Assert
      must_respond_with :success
    end
    it "can not update orders with status paid" do

      get edit_order_path(orders(:paid_order))
      expect(flash[:error]).must_equal "We are processing your order. Please call us at 911 if you want to make changes! Thank you!"
      must_redirect_to order_path(orders(:paid_order))
    end

  end

  describe "update" do
    it "will update order " do
      order = orders(:order1)
      order_hash = {
          order: {
              name: "updated name",
          },
      }

      expect { patch order_path(order.id), params: order_hash }.must_differ "Order.count", 0
      expect(order.reload.name).must_equal "updated name"
    end


    it "can not update order if no order items " do
      empty_order = orders(:empty_order)

      order_hash = {
          order: {
              name: "update",
          },
      }

      expect { patch order_path(empty_order.id), params: order_hash }.must_differ "Order.count", 0
      expect(flash[:error]).must_equal "There is no item in your cart!"
    end

    it "returns error if items in cart no longer have enough quantity in stock" do
      order = orders(:order1)

      order.order_items.each do |order_item|
        order_item.product.in_stock = 0
        order_item.product.save!
      end

      patch order_path(order)

      expect(flash[:error]).must_equal "Our stock have changed. We have updated your cart to reflect the available quantity."

      must_redirect_to shopping_cart_path(order.id)
    end

    it "reduces quantity of order items if product inventory is less than order item quantity" do
      order = orders(:order1)

      order.order_items.each do |order_item|
        order_item.quantity = 2
        order_item.product.in_stock = 1
        order_item.product.save!
      end

      patch order_path(order)

      order.order_items.each do |order_item|
        expect(order_item.reload.quantity).must_equal 1
      end

      expect(flash[:error]).must_equal "Our stock have changed. We have updated your cart to reflect the available quantity."
      must_redirect_to shopping_cart_path(order.id)
    end
  end

  describe 'confirmation' do

    it 'can get a confirmation page' do
      get order_confirmation_path(orders(:paid_order))
      must_respond_with :ok
    end

    it 'responds with bad request of page not found' do
      get order_confirmation_path(-1)

      must_respond_with :redirect
      expect(flash.now[:error]).must_equal "Something happened! Please try again!"
    end
  end

end