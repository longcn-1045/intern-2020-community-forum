class Topic < ApplicationRecord
  TOPIC_PARAMS = %i(name status).freeze
  enum status: {off: 0, on: 1}

  has_many :posts, dependent: :destroy

  validates :name, presence: true,
      length: {maximum: Settings.topic.validates.name_topic}

  scope :order_created_at, ->{order created_at: :desc}
end
