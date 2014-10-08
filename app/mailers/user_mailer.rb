class UserMailer < ActionMailer::Base
	default from: "espelho.politico@sandboxcc645a9df82541d3b50acd6558a37194.com"

	def account_activation(user)
		@user = user
		mail(to: @user.email, subject: "Verificação de Conta do Espelho Político")
	end
end