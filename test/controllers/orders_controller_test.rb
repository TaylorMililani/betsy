require "test_helper"

describe OrdersController do
  before do
    @order_hash = {
        order: {
            name: "name",
            email: "aaa@aa.com",
            address: "1234 Main st",
            cvv: 123,
            cc_num: "4539 1488 0343 6467",
            cc_expiration: 1121,
            billing_zip: 12345,
        },
    }
  end

  describe "create " do

    it "can create a new order" do

      expect { post orders_path, params: @order_hash }.must_differ "Order.count", 1
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


  describe "show" do
    before do
      perform_login(users(:user1))
    end

    it "can see order details if the order includes order_items from the logged in merchant" do

      order = orders(:order1)
      patch order_path(order), params: @order_hash

      get order_path(order)
      must_respond_with :success
    end

    it "cannot see the order if the order does not include order_items from the logged in merchant" do
      order = orders(:order2)
      patch order_path(order), params: @order_hash
      get order_path(order)

      must_respond_with :redirect
      expect(flash[:error]).must_equal "You are not authorized to view this! Sneaky!"
    end

    it "will be redirected if the order does not exist" do
      get order_path(-1)
      must_respond_with :redirect
      expect(flash[:error]).must_equal "Invalid Order"
    end
  end

  describe "update" do
    it "will update order " do
      order = orders(:order1)
      @order_hash = {
          order: {
              name: "updated name",
          },
      }

      expect { patch order_path(order.id), params: @order_hash }.must_differ "Order.count", 0
      expect(order.reload.name).must_equal "updated name"
    end


    it "can not update order if no order items " do
      empty_order = orders(:empty_order)

      @order_hash = {
          order: {
              name: "update",
          },
      }

      expect { patch order_path(empty_order.id), params: @order_hash }.must_differ "Order.count", 0
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
        quantity = order_item.product.in_stock
        expect(quantity).must_equal 1
      end

      expect(flash[:error]).must_equal "Our stock have changed. We have updated your cart to reflect the available quantity."
      must_redirect_to shopping_cart_path(order.id)
    end

    it "changes the status of the order to paid when successfully updated the order" do
      order = orders(:order1)
      patch order_path(order), params: @order_hash
      expect(order.reload.status).must_equal "paid"
      expect(flash[:success]).must_equal "Your order ##{order.id} has been placed!"
    end

  end

  describe 'confirmation' do

    it 'can go to confirmation page after checkout' do
      order = orders(:order1)
      patch order_path(order), params: @order_hash

      must_respond_with :redirect
      assert_redirected_to order_confirmation_path(order)

    end

    it 'cannot go back to confirmation page' do
      order = orders(:order1)
      patch order_path(order), params: @order_hash
      get order_confirmation_path(order)

      must_respond_with :redirect
      expect(flash[:error]).must_equal "You are not authorized to view this! Sneaky!"
    end

    it 'responds with bad request of page not found' do
      get order_confirmation_path(-1)

      must_respond_with :redirect
      expect(flash[:error]).must_equal "Something happened! Please try again!"
    end
  end

  describe "cancelorder" do
    it "will change order status to cancelled" do
       order = orders(:order1)
       patch cancel_order_path(order.id)
       expect(order.reload.status).must_equal "cancelled"
    end
  end

  describe "completeorder" do
    it "will change order status to complete" do
      order = orders(:order1)
      patch complete_order_path(order.id)
      expect(order.reload.status).must_equal "complete"
    end
  end

end