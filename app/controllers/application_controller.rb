class ApplicationController < ActionController::Base
  #helper_method :current_user
  before_action :current

  def current
    @current_user = User.find_by(id: session[:user_id])

    #to test action under merchant account comment out upper line uncomment lower
    # @current_user = User.find_by(id: 1)

    # unless @current_user
    #   flash[:error] = "You are not logged in"
    #   redirect_to root_path
    #   return
    # end
  end



  def require_login
    unless @current_user
      flash[:error] = "You must be logged in to see this page"
      redirect_to root_path
      return
    end
  end

  # def require_login
  #   if @current_user.nil?
  #     flash[:error] = "You must be logged in to view this page"
  #     redirect_to root_path
  #   end
  # end
  #
  # def only_see_own_page
  #         @user = User.find_by(id: params[:id])
  #
  #         if @current_user != @user
  #           redirect_to root_path, notice: "Sorry, but you are only allowed to view your own profile page."
  #         end
  #     end

end
