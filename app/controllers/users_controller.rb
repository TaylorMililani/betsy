class UsersController < ApplicationController
    def create
        auth_hash = request.env["omniauth.auth"]
        user = User.find_by(uid: auth_hash[:uid], provider: "github")
        if user
            flash[:success] = "Logged in as returning user #{user.username}"
        else
            user = User.build_from_github(auth_hash)
        end

        if user.save
            flash[:success] = "Logged in as new user #{user.username}"
        else
            flash[:error] = "Could not create new user account: #{user.errors.messages}"
            return redirect_to root_path
        end

        session[:user_id] = user.id
        return redirect_to root_path
    end
end
