require "test_helper"

describe Category do
  before do
    @category = categories(:cat1)
    @product = products(:product1)
  end

  describe "validations" do
    before do
      @new_cat = Category.new(name: "category")
    end

    it "is valid when the name field is present and unique" do
      expect(@new_cat.valid?).must_equal true
    end

    it "is invalid when the name field is missing" do
      @new_cat.name = nil

      expect(@new_cat.valid?).must_equal false
      expect(@new_cat.errors.messages).must_include :name
      expect(@new_cat.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "is invalid with a non-unique name, case-insensitive" do
      @new_cat.save!
      other_cat = Category.new(name: "Category")
      upcase_cat = Category.new(name: "CATEGORY")

      expect(other_cat.valid?).must_equal false
      expect(other_cat.errors.messages).must_include :name
      expect(other_cat.errors.messages[:name]).must_equal ["has already been taken"]

      expect(upcase_cat.valid?).must_equal false
      expect(upcase_cat.errors.messages).must_include :name
      expect(upcase_cat.errors.messages[:name]).must_equal ["has already been taken"]
    end
  end

  describe "relations" do

    it "has and belongs to many products " do
      expect(@category.products).wont_be_empty
      expect(@category.products).must_include @product
      expect(@product.categories).must_include @category
    end
  end

end