class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy

  has_many :user_topics, dependent: :destroy
  has_many :users, through: :user_topics

  validates :name, presence: true,
  length: {maximum: Settings.user.validates.max_name},
  uniqueness: true

  class << self
    def search query
      if query
        self.where('name LIKE ?', "%#{query}%")
      else
        self.all
      end
    end
  end
end
