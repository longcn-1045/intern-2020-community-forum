class UserTopic < ApplicationRecord
  belongs_to :user
  belongs_to :topic, counter_cache: :user_topics_count

  validates :topic_id, :user_id, presence: true
end
