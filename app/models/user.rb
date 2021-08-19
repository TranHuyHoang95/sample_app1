class User < ApplicationRecord
  attr_accessor :remember_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze
  before_save{email.downcase!}
  validates :name, presence: true, length: {maximum: Settings.length.max_name}
  validates :email, presence: true, length: {
    maximum: Settings.length.max_email
  }, format: {
    with: VALID_EMAIL_REGEX
  }, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {
    minimum: Settings.length.min_password
  }
  has_secure_password

  def self.digest string
    if cost = ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
