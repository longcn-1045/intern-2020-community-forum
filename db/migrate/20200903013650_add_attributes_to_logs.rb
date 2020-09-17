class AddAttributesToLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :logs, :controller, :string
    add_column :logs, :action, :string
    add_column :logs, :browser, :string
    add_column :logs, :ip_address, :string
  end
end
