class UsersController < ApplicationController
    before_action :only_see_own_page, only: :show

    def index
        @users = User.all
        @user_products = Product.where(user_id: params[:id])
    end

    def show_user
        @user = User.find_by(id: params[:id])

        if @user.nil?
            head :not_found
            return
        end
    end

    def create
        auth_hash = request.env["omniauth.auth"]
        user = User.find_by(uid: auth_hash[:uid], provider: "github")
        if user
            flash[:success] = "Logged in as returning user #{user.username}"
        else
            user = User.build_from_github(auth_hash)

            if user.save
                flash[:success] = "Logged in as new user #{user.username}"
            else
                flash[:error] = "Could not create new user account: #{user.errors.messages}"
                return redirect_to root_path
            end
        end

        session[:user_id] = user.id
        return redirect_to root_path
    end

    def destroy
        session[:user_id] = nil
        flash[:success] = "Successfully logged out"

        redirect_to root_path
    end

    def manage_orders
    end


    def only_see_own_page
        @user = User.find_by(id: params[:id])
      
        if @current_user != @user
          redirect_to root_path, notice: "Sorry, but you are only allowed to view your own profile page."
        end
    end

    private
    def user_params
        params.require(:user).permit(:email, :uid, :provider, :username)
    end

    
end
