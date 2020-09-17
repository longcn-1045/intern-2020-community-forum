class ChangeColumnContentLogs < ActiveRecord::Migration[6.0]
  def change
    change_column :logs, :content, :text
  end
end
