class UsersController < ApplicationController
	before_action :signed_in_user, only: [:index, :edit, :update]
	before_action :correct_user, only: [:edit, :update]
	before_action :admin_user, only: :destroy

# :nocov:

	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

# :nocov:

	def new
		@user = User.new
	end

	def edit
	end

	def create
		@user = User.new(user_params)
		if @user.save
			@user.send_activation_email
			flash[:info] = 'Por favor, verifique seu email para ativar sua conta'
			redirect_to root_url
		else
			render 'new'
		end
	end

	def update
		@user.update(user_params)
		flash[:notice] = 'Usuário atualizado com sucesso!' if @user.save
		redirect_to users_url
	end

	def destroy
		User.find(params[:id]).destroy
		flash.now[:sucess] = 'Usuário foi excluído com sucesso!'
		redirect_to users_url
	end

# :nocov:

	def authenticate
		@user = User.find(params[:id])
	end

# :nocov:

	private
		def user_params
			params.require(:user).permit(:name, :email, :password, :username, :password_confirmation)
		end

		# Confirma um usuário logado
		def signed_in_user
			unless signed_in?
				store_location
				flash[:danger] = "Por favor, entre na sua conta"
				redirect_to signin_url
			end
		end

		# Confirma o usuário certo
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user)
		end

		# Confirma um ausuário com direito de administrador
		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end
end