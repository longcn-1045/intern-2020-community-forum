class AddUsersCountToTopics < ActiveRecord::Migration[6.0]
  def self.up
    add_column :topics, :user_topics_count, :integer, null: false, default: 0

    Topic.reset_column_information
    Topic.find_each do |t|
      Topic.update_counters t.id, user_topics_count: t.users.length
    end
  end

  def self.down
    remove_column :topics, :user_topics_count
  end
end
