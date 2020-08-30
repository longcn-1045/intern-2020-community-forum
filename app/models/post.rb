class Post < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.user.validates.content}
  validates :title, presence: true,
    length: {maximum: Settings.user.validates.title}
end
