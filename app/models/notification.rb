class Notification < ApplicationRecord
  belongs_to :post
  belongs_to :user

  delegate :title, to: :post
  delegate :name, to: :user

  enum action: {created: 0, updated: 1, deleted: 2}
  enum viewed: {uncheck: 0, checked: 1}

  scope :order_created_at, ->{order created_at: :desc}
end
