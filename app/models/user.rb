class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  before_save :alter_email
  before_create :create_activation_digest

  PERMITTED_FIELDS = [:name, :email, :password, :password_confirmation].freeze

  validates :name, presence: true,
                    length: {maximum: Settings.validation.name.max_length}

  validates :email, presence: true,
                    length: {maximum: Settings.validation.email.max_length},
                    format: {with: Settings.validation.email.valid_regex},
                    uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence: true,
                      length: {
                        minimum: Settings.validation.password.min_length
                      },
                      allow_nil: true

  def self.digest string
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create string, cost: cost
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private

  def alter_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
