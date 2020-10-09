class AddFieldToPostUser < ActiveRecord::Migration[6.0]
  def up
    add_column :posts, :off_date, :datetime, null: true,
      default: DateTime.now
    add_column :users, :warning_date, :datetime, null: true,
      default: DateTime.now
  end

  def down
    remove_column :users, :warning_date
    remove_column :posts, :off_date
  end
end
