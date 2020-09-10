class ChangeStatusToPost < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :status, :integer, default: 2, null: true
  end
end
