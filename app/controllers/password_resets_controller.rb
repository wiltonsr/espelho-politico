class PasswordResetsController < ApplicationController
	before_action :get_user, only: [:edit, :update]

	def new
	end

	def create
		@user = User.find_by(email: params[:password_resets][:email].downcase)
		if @user
			@user.create_reset_digest
			@user.send_password_reset_email
			flash[:info] = "Enviado email com instruções para redefinir a senha"
			redirect_to root_url
		else
			flash.now[:danger] = "Endereço de email não encontrado"
			render 'new'
		end
	end

	def edit
	end

	def update
    if @user.password_reset_expired?
      flash[:danger] = "O tempo para redefinição de senha expirou"
      redirect_to new_password_reset_path
    elsif @user.update_attributes(user_params)
      if (params[:user][:password].blank? &&
          params[:user][:password_confirmation].blank?)
        flash.now[:danger] = "Senha e confirmação de senha não podem estar em branco"
        render 'edit'
      else
        flash[:success] = "A senha foi redefinida com sucesso"
        sign_in @user
        redirect_to @user
      end
    else
      render 'edit'
    end
  end

	private
		def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
		def get_user
			@user = User.find_by(email: params[:email])
			unless @user && @user.authenticated?(:reset, params[:id])
				redirect_to root_url
			end
		end
end
