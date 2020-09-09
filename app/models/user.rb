class User < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name email password password_confirmation
                          avatar_cache avatar).freeze

  enum role: {member: 0, admin: 1}
  enum status: {active: 0, block: 1}

  mount_uploader :avatar, AvatarUploader

  attr_accessor :remember_token, :activation_token, :reset_token

  has_many :posts, dependent: :destroy

  accepts_nested_attributes_for :posts

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

  scope :order_created_at, ->{order created_at: :desc}
  scope :all_except, ->(user){where.not(id: user)}

  before_save :downcase_email

  delegate :url, to: :avatar

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

  def display_image
    image.variant resize_to_limit: [Settings.user.validates.image_size_limit,
      Settings.user.validates.image_size_limit]
  end

  private

  def downcase_email
    email.downcase!
  end
end
