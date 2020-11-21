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
end
