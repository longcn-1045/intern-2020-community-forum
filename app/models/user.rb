class User < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name email password password_confirmation).freeze

  attr_accessor :remember_token, :activation_token, :reset_token

  validates :name, presence: true,
      length: {maximum: Settings.user.validates.max_name}
  validates :email, presence: true,
      length: {maximum: Settings.user.validates.max_email},
      format: {with: Settings.user.validates.string},
      uniqueness: {case_sensitive: false}
  validates :password, presence: true,
      length: {minimum: Settings.user.validates.min_pass},
      allow_nil: true

  has_secure_password

  before_save :downcase_email

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
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
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update remember_digest: nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
