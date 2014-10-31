class SessionsController < Devise::SessionsController
   def create
    user = User.find_by_username(params[:user][:username].downcase)

    if user && user.valid_password?(params[:user][:password])
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(:user, user)
      respond_with user, :location => after_sign_in_path_for(user)
    else
      flash[:alert] = "Invalid password"
      redirect_to new_user_session_path
    end
  end
end
