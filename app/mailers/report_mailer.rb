class ReportMailer < ApplicationMailer
  def report_email report_id
    report = PostReport.find report_id
    @reports_post = Post.find_by id: report.post.id
    @user = @reports_post.user
    @reports = @reports_post.post_reports

    mail to: @user.email, subject: t("block_mailer.blocked_email.block")
  end
end
