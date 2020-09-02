class UserTopic < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  validates :topic_id, :user_id, presence: true
end
