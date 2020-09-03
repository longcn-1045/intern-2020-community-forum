class Post < ApplicationRecord
  POST_PARAMS = %i(title content status topic_id image image_cache).freeze

  enum status: {off: 0, on: 1}

  mount_uploader :image, ImageUploader

  delegate :name, to: :user

  validates :user_id, presence: true
  validates :title, presence: true,
      length: {maximum: Settings.post.validates.max_title}
  validates :content, presence: true,
      length: {maximum: Settings.post.validates.max_content}
  validates :topic_id, presence: true

  belongs_to :user
  belongs_to :topic

  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  scope :order_created_at, ->{order created_at: :desc}
end
