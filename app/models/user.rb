class User < ActiveRecord::Base

	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

	def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
		user = User.where(:provider => auth.provider, :uid => auth.uid).first
		if user
			return user
		else
			registered_user = User.where(:email => auth.info.email).first
			if registered_user
				return registered_user
			else
				user = User.create(
					name:auth.extra.raw_info.name,
          provider:auth.provider,
          uid:auth.uid,
          email:auth.info.email,
          password:Devise.friendly_token[0,20]
        )
			end
		end
	end

	# Retorna o hash da string fornecida.
	# :nocov:
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

	# Define os atributos da redefinição de senha
	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	# Envia o email de redefinição de senha
	def send_password_reset_email
		UserMailer.password_reset(self).deliver
	end

	# Retorna verdadeiro se o tempo para redefinição de senha expirou
	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end

	private
		# Cria e assina a atribui o token e digest de ativação
		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end
end
