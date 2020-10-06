class User < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name email password password_confirmation
                          avatar_cache avatar).freeze

  mount_uploader :avatar, AvatarUploader

  attr_accessor :higher

  ransack_alias :user, :name_or_email

  has_many :posts, dependent: :destroy

  has_many :activities, as: :owner, dependent: :destroy

  has_many :post_marks, dependent: :destroy
  has_many :mark_posts, through: :post_marks, source: :post
  has_many :notifications, dependent: :destroy

  has_many :post_likes, dependent: :destroy
  has_many :like_posts, through: :post_likes, source: :post

  has_many :user_topics, dependent: :destroy
  has_many :topics, through: :user_topics

  has_many :active_relationships, class_name: Relationship.name,
  foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: Relationship.name,
  foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :post_comments, dependent: :destroy

  devise :database_authenticatable, :registerable, :rememberable,
         :validatable, :confirmable, :lockable, :timeoutable

  validates :name, presence: true,
    length: {maximum: Settings.user.validates.max_name}
  validates :email, presence: true,
    uniqueness: {case_sensitive: true},
    length: {maximum: Settings.user.validates.max_email},
    format: {with: Devise.email_regexp}
  validates :password, presence: true,
    length: {within: Devise.password_length},
    allow_nil: true

  enum role: {member: 0, admin: 1}
  enum status: {active: 0, block: 1}

  scope :order_created_at, ->{order created_at: :desc}
  scope :order_updated_at, ->{order updated_at: :desc}
  scope :all_except, ->(user){where.not(id: user)}
  scope :by_user_name, (lambda do |opt|
    where("name like ? OR email like ?", "#{opt}%", "#{opt}%") if opt.present?
  end)
  scope :by_status, ->(status){where status: status if status.present?}
  scope :by_role, ->(role){where role: role if role.present?}
  scope :order_by_post_count, (lambda do |opt|
    order posts_count: opt if opt.present?
  end)
  scope :order_by_name, ->{order name: :asc}
  scope :order_followers_count, ->{order follower_users_count: :desc}
  scope :not_followers, (lambda do |user|
    where.not(id: user.following_ids)
  end)

  scope :user_ids, (lambda do |user_filtered|
    where(id: user_filtered) if user_filtered.present?
  end)

  before_save :downcase_email

  delegate :url, to: :avatar

  class << self
    def sort_type sort
      if sort.eql? "created_at"
        order_created_at
      elsif sort.eql? "alphabet"
        order_by_name
      elsif sort.eql? "followers"
        order_followers_count
      else
        all
      end
    end

    def by_follow_status status, user
      if status.eql? "on"
        user.following
      elsif status.eql? "off"
        not_followers(user)
      else
        all
      end
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

  def follow_topic topic
    topics << topic
  end

  def unfollow_topic topic
    topics.delete topic
  end

  def follow_topic? topic
    topics.include? topic
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  def author? post
    posts.include? post
  end

  private

  def downcase_email
    email.downcase!
  end
end
