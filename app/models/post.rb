class Post < ApplicationRecord
  PERMIT_ATTRIBUTES = [
    :title,
    :content,
    :topic_id,
    tags_attributes: [:id, :name, :_destroy].freeze
  ].freeze

  belongs_to :user
  belongs_to :topic

  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  has_many :post_marks, dependent: :destroy
  has_many :mark_users, through: :post_marks, source: :user

  has_many :post_likes, dependent: :destroy
  has_many :like_users, through: :post_likes, source: :user

  accepts_nested_attributes_for :tags,
                                allow_destroy: true,
                                reject_if: :reject_tags

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.user.validates.content}
  validates :title, presence: true,
    length: {maximum: Settings.user.validates.title}

  private

  def reject_tags attributes
    attributes[:name].blank?
  end
end
