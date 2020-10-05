# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[6.0]
  def up
    change_table :users do |t|
      t.change_default :email, from: nil, to: ""
      t.string :encrypted_password, null: false, default: ""

      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.datetime :remember_created_at

      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      t.integer  :failed_attempts, default: 0, null: false
      t.string   :unlock_token
      t.datetime :locked_at
    end

    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
