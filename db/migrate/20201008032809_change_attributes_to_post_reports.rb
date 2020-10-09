class ChangeAttributesToPostReports < ActiveRecord::Migration[6.0]
  def up
    remove_column :post_reports, :content

    add_column :post_reports, :report_reason_id, :integer
    add_column :post_reports, :report_reason_content, :text, null: true
  end

  def down
    add_column :post_reports, :content, :text, null: true
    remove_column :post_reports, :report_reason_content
    remove_column :post_reports, :report_reason_id
  end
end
