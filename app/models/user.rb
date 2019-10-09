class User < ApplicationRecord
  USER_PARAMS = %i(name email password password_confirmation).freeze
  before_save :downcase_email
    
  validates :name,  presence: true, length: {maximum: Settings.username_maximum}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.email_maximum}, 
  format: {with: VALID_EMAIL_REGEX},
  uniqueness: true
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.password_minimum}

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  private

  def downcase_email
    self.email = email.downcase
  end 
end
