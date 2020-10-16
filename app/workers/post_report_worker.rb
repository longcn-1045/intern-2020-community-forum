class PostReportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform report_id
    ReportMailer.report_email(report_id).deliver
  end
end
