class ChangeStatusPost < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :status, :integer, default: 1, null: true
  end
end
