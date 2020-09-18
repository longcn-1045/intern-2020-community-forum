module NotificationsHelper
  def check_notification status
    status ? "text-danger" : "text-success"
  end
end
