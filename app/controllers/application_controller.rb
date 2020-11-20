class ApplicationController < ActionController::Base
  helper_method :current_user

  # def current_user
  #   @current_user = User.find_by(uid: auth_hash[:uid], provider: "github")
  #   unless @current_user
  #     flash[:error] = "You are not logged in"
  #     redirect_to root_path
  #     return
  #   end
  # end
end
