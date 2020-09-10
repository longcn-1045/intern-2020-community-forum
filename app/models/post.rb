class Post < ApplicationRecord
  POST_PARAMS = [
    :title,
    :content,
    :status,
    :topic_id,
    :image,
    :image_cache,
    tags_attributes: [:id, :name, :_destroy].freeze
  ].freeze

  belongs_to :user
  belongs_to :topic

  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  accepts_nested_attributes_for :tags,
                                allow_destroy: true,
                                reject_if: :reject_tags

  validates :user_id, presence: true
  validates :title, presence: true,
      length: {maximum: Settings.post.validates.max_title}
  validates :content, presence: true,
      length: {maximum: Settings.post.validates.max_content}
  validates :topic_id, presence: true

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

  enum status: {off: 0, on: 1, pending: 2}

  mount_uploader :image, ImageUploader

  delegate :name, :url, to: :user

  delegate :name, to: :topic, prefix: true

  private

  def reject_tags attributes
    attributes[:name].blank?
  end
end
