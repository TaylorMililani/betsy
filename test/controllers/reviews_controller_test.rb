require "test_helper"

describe ReviewsController do
  describe "New" do
    it "gets the new review page" do
      get ''

      must_redirect_to new_product_review_path

      must_respond_with :success
    end
  end

  describe "Create" do

  end
end
