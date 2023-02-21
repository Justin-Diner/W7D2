class User < ApplicationRecord
	validates :email, :password_digest, presence: true, uniqueness: true
	validates :password_digest, presence: true 
	validates :password, length: {minimum: 6}, allow_nil: true 

	before_validation :ensure_session_token
	attr_reader :password 

	def self.find_by_credentials(username, password) # locates user
		user = User.find_by(username: username)
		if user && user.is_password?(password) 
			return user
		else
			return nil 
		end
	end

	def password=(password) #sets the password digest and password
		self.password_digest = BCrypt::Password.create(password)
		@password = password
	end

	def is_password? # Checks the password when a user logs in
		bcrypt_obj = BCrypt::Password.new(self.password_digest)
		bcrypt_obj.is_password?(password)
	end

	def generate_unique_session_token # generates a new session token (and ensures it is unique)
		token = SecureRandom::urlsafe_base64
		while user.exists?(session_token: token)
			token = SecureRandom::urlsafe_base64
		end
		token 
	end

	def ensure_session_token # ensures the user has a session token
		self.session_token ||= generate_unique_session_token
	end

	def reset_session_token # resets the session token
		self.session_token = generate_unique_session_token
		self.save!
		self.session_token
	end
end
