class PostReport < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(post_id report_reason_id report_reason_content).freeze

  belongs_to :post
  belongs_to :user
  belongs_to :report_reason

  validates :report_reason_content,
            length: {maximum: Settings.user.validates.content}
  belongs_to :post, counter_cache: :posts_report
  belongs_to :user

  after_commit :check_block, on: %i(create)

  scope :order_updated_at, ->{order updated_at: :desc}

  delegate :name, to: :user, prefix: true
  delegate :title, to: :post, prefix: true

  private

  def check_block
    report_post = post
    return unless report_post.posts_report > Settings.report.number.block

    report_post.off!
    PostReportWorker.perform_async id
    flash[:notice] = t("report.title")
  end
end
