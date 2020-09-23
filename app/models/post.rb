class Post < ApplicationRecord
  include PublicActivity::Model
  tracked owner: ->(_controller, model){model && model.user}

  POST_PARAMS = [
    :title,
    :content,
    :status,
    :topic_id,
    :image,
    :image_cache,
    tags_attributes: [:id, :name, :_destroy].freeze
  ].freeze

  attr_accessor :editor_id

  belongs_to :user, counter_cache: :posts_count
  belongs_to :topic

  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :notifications, dependent: :destroy

  after_commit :notify, on: %i(create update)

  has_many :post_marks, dependent: :destroy
  has_many :mark_users, through: :post_marks, source: :user

  has_many :post_likes, dependent: :destroy
  has_many :like_users, through: :post_likes, source: :user

  validates :user_id, presence: true
  validates :title, presence: true,
      length: {maximum: Settings.post.validates.max_title}
  validates :content, presence: true,
      length: {maximum: Settings.post.validates.max_content}
  validates :topic_id, presence: true

  accepts_nested_attributes_for :tags,
                                allow_destroy: true,
                                reject_if: :reject_tags

  scope :order_updated_at, ->{order updated_at: :desc}
  scope :order_created_at, ->{order created_at: :desc}
  scope :by_title, (lambda do |title|
    where("title like ?", "#{title}%") if title.present?
  end)
  scope :by_status, ->(status){where status: status if status.present?}
  scope :by_user_id, ->(user_id){where user_id: user_id if user_id.present?}
  scope :by_topic_id, (lambda do |topic_id|
    where topic_id: topic_id if topic_id.present?
  end)
  scope :order_mark_posts, (lambda do
    includes(:post_marks).order("post_marks.created_at desc")
  end)

  scope :by_topics, (lambda do |topic_ids|
    where topic_id: topic_ids
  end)

  scope :by_ids, (lambda do |post_ids|
    where(id: post_ids) if post_ids.present?
  end)

  scope :by_users, (lambda do |user_ids|
    where user_id: user_ids
  end)

  scope :in_homepage, (lambda do |topic_ids, user_ids|
    by_topics(topic_ids).or(by_users(user_ids))
                        .on
  end)

  enum status: {off: 0, on: 1, pending: 2}

  mount_uploader :image, ImageUploader

  delegate :name, :url, to: :user

  delegate :name, to: :topic, prefix: true

  def post_score
    @post_score = post_likes.count +
                  (created_at.to_i - Settings.project_start_time) /
                  Settings.load_post_time
  end

  private

  def reject_tags attributes
    attributes[:name].blank?
  end

  def get_action notify
    if transaction_include_any_action?([:create])
      notify.created!
    elsif transaction_include_any_action?([:update])
      notify.updated!
    else
      notify.deleted!
    end
  end

  def notify
    notify_id = editor_id.presence || user_id
    notify = Notification.create(post_id: id, user_id: notify_id)
    get_action notify
    User.admin.each do |user|
      ActionCable.server.broadcast "notification_channel_#{user.id}", content:
        {notification_html: notification_html, count: Notification.uncheck.size}
    end
  end

  def notification_html
    @notify = Notification.includes :user, :post
    AdminController.render(
      partial: "admin/notifications/notification_center",
      locals: {notifications:
        @notify.order_created_at.take(Settings.user.validates.page)},
      formats: [:html]
    )
  end
end
