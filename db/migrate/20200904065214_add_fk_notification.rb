class AddFkNotification < ActiveRecord::Migration[6.0]
  def change
    add_reference :notifications, :user, index: true, foreign_key: true
    add_reference :notifications, :post, index: true, foreign_key: true
  end
end
