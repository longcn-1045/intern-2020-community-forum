class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates :name, presence: true,
  length: {maximum: Settings.user.validates.max_name}
end
