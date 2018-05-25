class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  attr_accessor :remember_token, :activation_token, :reset_token

  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }
  validates :surname, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } 
  validates :biography, absence: true, unless: proc { |model| model.class != User }
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  validate :thirty_days_old?

  before_save :downcase_email
  before_create :create_activation_digest

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

  # Return true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Remember a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
  end

  # Forget a user
  def forget
    update_column(:remember_digest, nil)
  end

  # Activate user account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Send an activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # Set the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  # Send password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Return true if a password reset has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  # Convert email to all lower-case
  def downcase_email
    email.downcase!
  end

  # Generate an activation token and an activation digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  # Update author status if older than 30 days
  def thirty_days_old?
    if author? && Time.zone.now - created_at < 30.days
      errors.add :created_at, 'should be at least 30 days old'
    end
  end
end

