class User < ApplicationRecord
  PERMIT_ATTRIBUTES =
    %i(
      name
      email
      password
      password_confirmation
      avatar
    ).freeze

  enum role: {member: 0, admin: 1}
  enum status: {active: 0, block: 1}

  attr_accessor :remember_token, :activation_token, :reset_token

  has_many :posts, dependent: :destroy

  has_many :post_marks, dependent: :destroy
  has_many :mark_posts, through: :post_marks, source: :post

  has_many :post_likes, dependent: :destroy
  has_many :like_posts, through: :post_likes, source: :post

  mount_uploader :avatar, AvatarUploader

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

  def save_post post
    mark_posts << post
  end

  def unsave_post post
    mark_posts.delete post
  end

  def save_post? post
    mark_posts.include? post
  end

  def like_post post
    like_posts << post
  end

  def unlike_post post
    like_posts.delete post
  end

  def like_post? post
    like_posts.include? post
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
