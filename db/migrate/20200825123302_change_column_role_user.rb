class ChangeColumnRoleUser < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :role_id, :boolean, default: 0, null: true
  end
end
