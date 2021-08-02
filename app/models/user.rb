class User < ApplicationRecord
  before_save :alter_email

  PERMITTED_FIELDS = [:name, :email, :password, :password_confirmation].freeze

  validates :name, presence: true,
                    length: {maximum: Settings.validation.name.max_length}

  validates :email, presence: true,
                    length: {maximum: Settings.validation.email.max_length},
                    format: {with: Settings.validation.email.valid_regex},
                    uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence: true,
                      length: {minimum: Settings.validation.password.min_length}

  def self.digest string
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create string, cost: cost
  end

  private

  def alter_email
    email.downcase!
  end
end
