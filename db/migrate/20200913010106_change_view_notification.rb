class ChangeViewNotification < ActiveRecord::Migration[6.0]
  def change
    change_column :notifications, :viewed, :integer, default: 0, null: true
  end
end
