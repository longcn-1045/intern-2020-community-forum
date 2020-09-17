class AddCommentableToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :post_comments, :commentable, polymorphic: true, null: false
  end
end
