class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  attr_accessor :remember_token

  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }
  validates :surname, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } 
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  before_save :downcase_email

  class << self
    # Return the hash digest of a string
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Generate a random token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Return the user's full name
  def full_name
    "#{name} #{surname}"
  end

  # Remember a user in the database for use in persistant sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Return true if the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forget a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  # Convert email to all lower-case
  def downcase_email
    email.downcase!
  end
end

