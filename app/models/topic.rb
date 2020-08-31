class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :name, presence: true,
  length: {maximum: Settings.user.validates.max_name},
  uniqueness: true
end
