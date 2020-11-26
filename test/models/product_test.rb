require "test_helper"

describe Product do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  #
  describe "validations" do
      #arrange
      before do
        @user = User.create(email: "michaelj@michael.com", uid: 12345, provider: "github", username: "Michael")
        @product = Product.create(name: "Michael Jordan", description: "Famous basketball player", price: 2000, in_stock: 20, photo: "url", user_id: @user.id)
      end
      it "is invalid without a name" do
        # act
        @product.name = nil

        # Assert
        expect(@product.valid?).must_equal false
        expect(@product.errors.messages).must_include :name
        expect(@product.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "is invalid name isn't unique" do
        #arrange
        product_1 = Product.create(name: "Michael Jordan", description: "Famous basketball player", price: 2000, in_stock: 20, photo: "url", user_id: @user.id)
        # act
        product_1.save

        # Assert
        expect(product_1.valid?).must_equal false
        expect(product_1.errors.messages).must_include :name
        expect(product_1.errors.messages[:name]).must_equal ["has already been taken"]
      end

      it 'is invalid without a price' do
        # Act
        @product.price = nil

        # Assert
        expect(@product.valid?).must_equal false
        expect(@product.errors.messages).must_include :price
        expect(@product.errors.messages[:price]).must_include "can't be blank"
      end

      it "is invalid with 0 price" do
        #arrange
        product_2 = Product.create(name: "LeBron James", description: "Amazing basketball player", price: 0, in_stock: 20, photo: "url", user_id: @user.id)
        # act
        product_2.save

        # Assert
        expect(product_2.valid?).must_equal false
        expect(product_2.errors.messages).must_include :price
        expect(product_2.errors.messages[:price]).must_equal ["must be greater than 0"]
      end

      it "is invalid if price is not a number" do
        #arrange
        product_2 = Product.create(name: "LeBron James", description: "Amazing basketball player", price: "aaa", in_stock: 20, photo: "url", user_id: @user.id)
        # act
        product_2.save

        # Assert
        expect(product_2.valid?).must_equal false
        expect(product_2.errors.messages).must_include :price
        expect(product_2.errors.messages[:price]).must_equal ["is not a number"]
      end
  end

  describe 'relations' do
    before do
      @user = User.create(email: "michaelj@michael.com", uid: 12345, provider: "github", username: "Michael")
      @product = Product.create(name: "Michael Jordan", description: "Famous basketball player", price: 2000, in_stock: 20, photo: "url", user_id: @user.id)
    end

    it 'belongs to a user' do
      expect(@product.user).must_equal @user
    end

    it 'has a order_item' do
      expect(@product).must_respond_to :order_items
    end

    it 'has many categories' do
      expect(@product).must_respond_to :categories
    end

    it 'belongs to categories' do
      expect(@product).must_respond_to :categories
    end

    it 'has many reviews' do
      expect(@product).must_respond_to :reviews
    end
  end

  describe "products in stock" do
    before do
      @user = User.create(email: "michaelj@michael.com", uid: 12345, provider: "github", username: "Michael")
      @product_1 = Product.create(name: "Michael Jordan", description: "Famous basketball player", price: 2000, in_stock:0, photo: "url", user_id: @user.id)
      @product_2 = Product.create(name: "Joy", description: "Noone", price: 2000, in_stock: 5, photo: "url", user_id: @user.id)
    end
    it "returns products where in stock greater than 0" do

      expect(Product.products_in_stock).must_include @product_2
      expect(Product.products_in_stock.include? @product_1).must_equal false
    end
  end
end

# has_and_belongs_to_many :categories
#   belongs_to :user
#   has_many :reviews
#   has_many :order_items
#   products_in_stock