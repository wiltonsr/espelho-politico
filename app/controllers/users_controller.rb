class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update, :destroy]
	respond_to :html, :json, :xml

	def index
		@users = User.all
	end

	def show
	end

	def new
		@user = User.new
	end

	def edit
	end

	def create
		@user = User.new(user_params)
		flash[:notice] = 'Usuário criado com sucesso!' if @user.save
		respond_with(@user)
	end

	def update
		@user.update(user_params)
		flash[:notice] = 'Usuário atualizado com sucesso!' if @user.save
		respond_with(@user)
	end

	def destroy
		@user.destroy
		flash[:notice] = 'Usuário foi excluído com sucesso'
		respond_with(@user)
	end

	def login
		user = User.find_by_email_user(params[:session][:email_user].downcase)
		if user && user.authenticate(params[:session][:password])
			sign_in user
			redirect_to user
		else
			flash[:error] = "E-mail/Senha inválida!]"
			render 'new'
		end
	end

	# def logout
	# 	sign_out
	# 	redirect_to root_url
	# end

	private
		def set_user
			@user = User.find(params[:id])
		end

		def user_params
			params.require(:user).permit(:name, :email, :password, :username, :password_confirmation)
		end
end