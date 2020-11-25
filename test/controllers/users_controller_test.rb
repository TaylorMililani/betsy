require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs into an existing user and redirects to root_path" do
      start_count = User.count
      user = users(:user1)

      #OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      perform_login(user)
      get auth_github_callback_path(:github)

      must_redirect_to root_path

      session[:user_id].must_equal user.id

      User.count.must_equal start_count
    end

    it "creates new user" do
      start_count = User.count
      user = User.new(provider: "github", uid: 99999, username: "test_user", email: "test@user.com")

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      get auth_github_callback_path(:github)

      must_redirect_to root_path

      User.count.must_equal start_count + 1

      session[:user_id].must_equal User.last.id
    end
  end

  describe "Logged in users" do
    before do
      perform_login(users(:user1))
    end

    describe "show" do
      it "succeeds for a user that exists" do
        user_id = User.first.id
        get user_path(user_id)
        must_respond_with :success
      end
    end
  end

  describe "index" do
    it "should get index" do
      get "/users"
      must_respond_with :success
    end
  #passed
  end

  describe "guest users" do
    it "can access the index" do
      get users_path
      must_respond_with :success
    end

    it "cannot access merchant dashboard" do
      user = users(:user1)

      get user_path(user)
      must_redirect_to root_path
      expect(flash[:error]).must_equal "Sorry, but you are only allowed to view your own profile page."
    end
  end
end


