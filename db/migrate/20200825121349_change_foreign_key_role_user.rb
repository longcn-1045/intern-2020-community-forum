class ChangeForeignKeyRoleUser < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :users, :roles
    add_foreign_key :users, :roles, null: false, default: 0
  end
end
