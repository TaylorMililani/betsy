class UsersController < ApplicationController

    def index
        @users = User.all
    end

    def show
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

    def current
        @current_user = User.find_by(uid: auth_hash[:uid], provider: "github")
        unless @current_user
            flash[:error] = "You are not logged in"
            redirect_to root_path
            return
        end
    end


    private
    def user_params
        params.require(:user).permit(:email, :uid, :provider, :username)
    end
end
