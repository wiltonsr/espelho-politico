class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable
	
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
	# def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
	# 	user = User.where(:provider => auth.provider, :uid => auth.uid).first
	# 	if user
	# 		return user
	# 	else
	# 		registered_user = User.where(:email => auth.info.email).first
	# 		if registered_user
	# 			return registered_user
	# 		else
	# 			user = User.create(
	# 				name:auth.extra.raw_info.name,
 #          provider:auth.provider,
 #          uid:auth.uid,
 #          email:auth.info.email,
 #          password:Devise.friendly_token[0,20]
 #        )
	# 		end
	# 	end
	# end

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
