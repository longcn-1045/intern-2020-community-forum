class AddViewedNotifications < ActiveRecord::Migration[6.0]
  def self.up
    add_column :notifications, :viewed, :integer, null: true
  end

  def self.down
    remove_column :notifications, :viewed
  end
end
