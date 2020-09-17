class Topic < ApplicationRecord
  TOPIC_PARAMS = %i(name status).freeze
  enum status: {off: 0, on: 1}

  has_many :posts, dependent: :destroy

  has_many :user_topics, dependent: :destroy
  has_many :users, through: :user_topics

  validates :name, presence: true,
    length: {maximum: Settings.topic.validates.name_topic},
    uniqueness: true

  scope :order_created_at, ->{order created_at: :desc}
  scope :order_by_user, (lambda do
    topic_count = UserTopic
      .group(:topic_id)
      .select(:topic_id, "count(topic_id) as num")

    joins("LEFT JOIN (#{topic_count.to_sql}) as topic_count
      ON topic_count.topic_id = id")
    .order("topic_count.num desc")
  end)
end
