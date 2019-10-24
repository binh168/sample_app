class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  USER_PARAMS = %i(name email password password_confirmation).freeze
  PASSWORD_RESET_PARAMS = %i(password password_confirmation).freeze
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: {maximum: Settings.username_maximum}
  validates :email, presence: true, length: {maximum: Settings.email_maximum}, 
    format: {with: Settings.validate_email}, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.password_minimum}, allow_nil: true

  scope :order_user, ->{order name: :desc}

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"

    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update remember_digest: nil
  end

  def activate
    update_attributes activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end 

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.reset_sent_at.hours.ago
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
