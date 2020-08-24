class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.boolean :status, default: false
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.references :topic, null: false, foreign_key: true
      t.integer :view

      t.timestamps
    end

    add_index :posts, [:user_id, :created_at, :topic_id]
  end
end
