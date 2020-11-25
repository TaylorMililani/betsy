require "test_helper"

describe Order do
  before do
    @new_order = Order.new(name: "name1", email: "aa@gmail.com", address: "15 Jane Street, Seattle, WA", cc_num: "4539 1488 0343 6467", cc_expiration: "1121",
                           cvv: 123, billing_zip: 12345 )
    @order1 = orders(:order1)

    @product1 = products(:product1)
    @new_product1 = Product.create(name: @product1.name, price: @product1.price, in_stock: @product1.in_stock)

    @new_order_item = OrderItem.create(product: @new_product, order: @new_order)
  end

  describe 'relations' do
    it 'has many order items' do
      expect(@order1).must_respond_to :order_items
    end
  end

  describe 'validations' do
    it 'is valid when parameters are present' do
      expect(@new_order.valid?).must_equal true
      expect(@new_order.name).must_equal @order1.name
    end

    it 'is invalid without a valid cc number' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(cc_num: "8273 1232 7352 0569")
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid with an invalid card number' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(cc_num: 1234)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without a cc expiration date' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(cc_expiration: nil)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without a cvv' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(cvv: nil)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid with an invalid cvv' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(cvv: 12345)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without an address' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(address: nil)
      expect(@new_order.valid?).must_equal false
    end


    it 'is invalid without a zip code' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(billing_zip: nil)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without a guest name' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(name: nil)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without an email' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(email: nil)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid with an invalid email' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(email: '1234.com')
      expect(@new_order.valid?).must_equal false
    end
  end

end
