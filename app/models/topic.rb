class Topic < ApplicationRecord
  TOPIC_PARAMS = %i(name status).freeze

  enum status: {off: 0, on: 1}

  has_many :posts, dependent: :destroy

  has_many :user_topics, dependent: :destroy
  has_many :users, through: :user_topics

  validates :name, presence: true,
    length: {maximum: Settings.topic.validates.name_topic},
    uniqueness: {case_sensitive: true}

  scope :order_created_at, ->{order created_at: :desc}
  scope :order_by_user, (lambda do
    topic_count = UserTopic
      .group(:topic_id)
      .select(:topic_id, "count(topic_id) as num")

    joins("LEFT JOIN (#{topic_count.to_sql}) as topic_count
      ON topic_count.topic_id = id")
    .order("topic_count.num desc")
  end)
  scope :by_topic_name, (lambda do |name|
    where("name like ?", "#{name}%") if name.present?
  end)
  scope :order_name, ->{order name: :asc}
  scope :order_topics_count, ->{order user_topics_count: :desc}
  scope :not_followers, (lambda do |user|
    where.not(id: user.topic_ids)
  end)

  class << self
    def sort_type sort
      if sort.eql? "created_at"
        order_created_at
      elsif sort.eql? "alphabet"
        order_name
      elsif sort.eql? "followers"
        order_topics_count
      else
        all
      end
    end

    def by_follow_status status, user
      if status.eql? "on"
        user.topics
      elsif status.eql? "off"
        not_followers(user)
      else
        all
      end
    end
  end
end
