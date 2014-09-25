class User < ActiveRecord::Base
	validates_presence_of :name, :email
	VALIDATED_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates_format_of :email, with: VALIDATED_EMAIL, on create 
	validates_lenght_of :email, maximum: 30, mesage: 'Digite um email com menos de 30 caracteres'
	validate_uniqueness_of :email
	has_secure_password
end