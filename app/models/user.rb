class User < ActiveRecord::Base
	attr_accessor :remember_token, :activation_token
	before_save :downcase_email_and_username
	before_create :create_activation_digest
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

	# Retorna o hash da string fornecida.
  def User.digest(string)
    if cost = ActiveModel::SecurePassword.min_cost
    	BCrypt::Engine::MIN_COST
    else
    	BCrypt::Engine.cost
		end
		BCrypt::Password.create(string, cost: cost)
	end

	# Retorna um token aleatório.
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	# Relembrar um usuário no banco de dados para ser usado em sessões permanentes.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Retorna verdadeiro se o token fornecido corresponde com o digest
	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		BCrypt::Password.new(digest).is_password?(token)
	end

	# Esquece o usuário
	def forget
		update_attribute(:remember_digest, nil)
	end

	# Ativa uma conta
	def activate
		update_attribute(:activated, true)
		update_attribute(:activated_at, Time.zone.now)
	end

	# Envia o email de ativação da conta
	def send_activation_email
		UserMailer.account_activation(self).deliver
	end

	private
			# Converte o email para caixa baixa
		def downcase_email_and_username
			self.email = email.downcase
			self.username = username.downcase
		end

		# Cria e assina a atribui o token e digest de ativação
		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end
end