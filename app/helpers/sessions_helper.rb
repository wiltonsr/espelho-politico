module SessionsHelper
	# Realiza sign-in no usuário fornecido.
	def sign_in(user)
    session[:user_id] = user.id
  end

	# Retorna o usuário que está logado, se exisstir.
	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
	end

	# Retorna "verdadeiro" se houver um usuário logado, e "falso" caso contrário
	def signed_in?
		!current_user.nil?
	end

	# Realiza o sign-out do usuário.
	def sign_out
    session.delete(:user_id)
    @current_user = nil
  end
end