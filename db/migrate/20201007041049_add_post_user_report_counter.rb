class AddPostUserReportCounter < ActiveRecord::Migration[6.0]
  def self.up
    add_column :posts, :posts_report, :integer, :null => false, default: 0

    Post.reset_column_information
    Post.find_each do |p|
      Post.update_counters p.id, posts_report: t.post_reports.length
    end
  end

  def self.down
    remove_column :posts, :posts_report
  end
end
