class RemoveContentNoitify < ActiveRecord::Migration[6.0]
  def change
    remove_column :notifications, :event
  end
end
