class ChangeNotificationTable < ActiveRecord::Migration[6.0]
  def self.up
    add_column :notifications, :content, :string, null: true
    add_column :notifications, :action, :integer, null: true
  end

  def self.down
    remove_column :notifications, :content
    remove_column :notifications, :action
  end
end
