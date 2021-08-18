class User < ApplicationRecord
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
end
