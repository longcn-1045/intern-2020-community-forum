class Activity < PublicActivity::Activity
  scope :order_created_at, ->{order created_at: :desc}

  def content
    action = key.split(".")[1]
    model = trackable_type.downcase

    content = [I18n.t("activities.you_have_just"), action, model].join(" ")

    if trackable.present?
      [content, trackable_info].join(" ")
    elsif action != "destroy"
      [content, I18n.t("activities.not_exist")].join(" ")
    else
      content
    end
  end

  private

  def trackable_info
    trackable.class.name == Post.name ? trackable.title : trackable.name
  end
end
