class AccountActivationsController < ApplicationController
	def edit
		user = User.find_by(email: params[:email])
		if user && !user.activated? && user.authenticated?(:activation, params[:id])
			user.activate
			flash[:sucess] = "Conta ativada com sucesso!"
			sign_in user
			redirect_to user
		else
			flash[:danger] = "Link de ativação inválido"
			redirect_to root_url
		end
	end
end