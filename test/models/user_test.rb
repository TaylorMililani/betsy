require "test_helper"

describe User do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  describe "validations" do
    before do
      @user = users(:user1)
    end

    it "is valid when all fields are present" do
      result = @user.valid?

      expect(result).must_equal true
    end

    it "is invalid without a username" do
      @user.username = nil

      result = @user.valid?

      expect(result).must_equal false
      expect(@user.errors.messages).must_include :username
    end

    it "is invalid with non unique username" do
      duplicate_item = @user.dup
      @user.save
      assert_not duplicate_item.valid?
    end

    it "is invalid without a email" do
      @user.email = nil

      result = @user.valid?

      expect(result).must_equal false
      expect(@user.errors.messages).must_include :email
    end

    it "is invalid with non unique email" do
      duplicate_item = @user.dup
      assert_not duplicate_item.valid?
      expect(duplicate_item.errors.messages).must_include :email
    end

    describe "relations" do

    end

  end
end
