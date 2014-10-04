class User < ActiveRecord::Base
	has_secure_password

	validates_presence_of :name, :email, :username, :password, message: 'Campo obrigatório'
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates_format_of :email, with: VALID_EMAIL_REGEX, :on => [:create, :update], message: 'Formato de email inválido'
	VALID_USERNAME_REGEX = /[a-z0-9._-]{5,30}/i
	validates_format_of :username, with: VALID_USERNAME_REGEX, :on  => [:create, :update], message: 'Formato inválido'
	validates_length_of :email, maximum: 30, mesage: 'Digite um email com menos de 30 caracteres'
	validates_length_of :username, within: 5..20,
		too_long: 'Digite um nome de usuário menor que 20 caracteres',
		too_short: 'Digite um nome de usuário maior que 5 caracteres'
	validates_length_of :password, within: 5..20,
		too_long: 'Digite um nome de usuário menor que 20 caracteres',
		too_short: 'Digite um nome de usuário maior que 5 caracteres'
	validates_uniqueness_of [:email, :username], case_sensitive: false
end