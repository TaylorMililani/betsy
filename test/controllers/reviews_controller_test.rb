require "test_helper"

describe ReviewsController do
  before do
    @user = User.create(username: "test", email: "test@test.com")
    @product = Product.create(name: "product", description: "test product", price: 10, in_stock: 2, user_id: @user.id)
    @review_hash = {
        review: {
            rating: 3,
            title: "good",
            text_field: "cool",
            product_id: @product.id
        }
    }
  end
  describe "New" do
    it "gets the new review page" do
      get new_product_review_path(product_id: @product.id)

      must_respond_with :success
    end
  end

  describe "Create" do
    it "can create a new review" do
      expect {
        post product_reviews_path(@product.id), params: @review_hash
      }.must_change "Review.count", 1
    end

    it "wont allow you to create a review for a product belonging to logged in user" do
      mock_auth_hash(@user)
      perform_login(@user)
      session[:user_id] = @user.id
      product = Product.create(name: "product", description: "test product", price: 10, in_stock: 2, user_id: session[:user_id])

      invalid_review = Review.new(rating: 3, title: "good", text_field: "cool", product_id: product.id)

      expect(invalid_review.valid?).must_equal false
      expect {
        invalid_review
      }.wont_change product.reviews.count

    end
  end
end
