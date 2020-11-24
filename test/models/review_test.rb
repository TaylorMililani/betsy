require "test_helper"

describe Review do
  before do
    @user = User.create(username: "test", email: "test@test.com")
    @product = Product.create(name: "product", description: "test product", price: 10, in_stock: 2, user_id: @user.id)
    @review = Review.create(rating: 3, title: "test", text_field: "test", product_id: @product.id)
  end

  it "can be instantiated" do
    expect(@review.valid?).must_equal true
  end

  describe "Relationships" do
    it "belongs to a product" do
      expect(@review.product).must_be_instance_of Product
    end
  end

  describe "Validations" do
    it "wont create new review if there is no rating" do
      review = Review.create(rating: nil, title: "test", text_field: "test", product_id: @product.id)

      expect(review.valid?).must_equal false
    end

    it "wont create a new review with invalid product id" do
      review = Review.create(rating: 1, title: "test", text_field: "test", product_id: -1)

      expect(review.valid?).must_equal false
    end
  end
end
