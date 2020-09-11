class AddPostCounter < ActiveRecord::Migration[6.0]
  def self.up
    add_column :users, :posts_count, :integer, :null => false, default: 0

    User.reset_column_information
    User.find_each do |u|
      User.reset_counters u.id, :posts
    end
  end

  def self.down
    remove_column :users, :posts_count
  end
end
