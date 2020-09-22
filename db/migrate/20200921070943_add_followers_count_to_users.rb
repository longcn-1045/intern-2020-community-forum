class AddFollowersCountToUsers < ActiveRecord::Migration[6.0]
  def self.up
    add_column :users, :follower_users_count, :integer, null: false,
      default: 0

    User.reset_column_information
    User.find_each do |t|
      User.update_counters t.id, follower_users_count: t.followers.count
    end
  end

  def self.down
    remove_column :users, :follower_topics_count
  end
end
