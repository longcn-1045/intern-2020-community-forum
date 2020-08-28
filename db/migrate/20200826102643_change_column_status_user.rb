class ChangeColumnStatusUser < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :status, :integer, null: true, default: 0
  end
end
