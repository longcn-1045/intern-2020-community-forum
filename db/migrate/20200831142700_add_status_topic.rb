class AddStatusTopic < ActiveRecord::Migration[6.0]
  def change
    add_column :topics, :status, :integer, null: true, default: 0
  end
end
