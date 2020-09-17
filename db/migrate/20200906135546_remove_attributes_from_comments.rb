class RemoveAttributesFromComments < ActiveRecord::Migration[6.0]
  def change
    remove_column :post_comments, :parent_id, :integer
    remove_column :post_comments, :post_id, :integer
  end
end
