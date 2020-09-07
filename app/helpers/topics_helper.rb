module TopicsHelper
  def topic_status status
    if status
      {
        css: Settings.status.on_status,
        status: t("post.index.on_status")
      }
    else
      {
        css: Settings.status.off_status,
        status: t("post.index.off_status")
      }
    end
  end
end
