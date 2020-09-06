class PostComment < ApplicationRecord
  PERMIT_ATTRIBUTES = :content

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :post_comments, dependent: :destroy, as: :commentable

  validates :content, presence: true,
    length: {maximum: Settings.user.validates.content}
end
