class Relationship < ApplicationRecord
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name,
    counter_cache: :follower_users_count

  validates :follower_id, :followed_id, presence: true
end
