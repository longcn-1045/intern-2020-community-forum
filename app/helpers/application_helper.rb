module ApplicationHelper
  FLASH_TYPES = {notice: "success", alert: "error"}.freeze

  def full_title page_title
    base_title = t ".title"
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def load_user_avatar avatar
    if avatar.present?
      image_tag avatar
    else
      image_tag Settings.user.default_avatar
    end
  end

  def display_error object, object_attr
    return unless object&.errors.present? && object.errors.key?(object_attr)

    errors = object.errors.messages[object_attr]
    content_tag :p, errors.join(", "), class: Settings.default_user.error_class
  end

  def load_follow_user_partial celeb
    if current_user.following? celeb
      render "users/unfollow", user: celeb
    else
      render "users/follow", user: celeb
    end
  end

  def load_follow_topic_partial topic
    if current_user.follow_topic? topic
      render "topics/unfollow", topic: topic
    else
      render "topics/follow", topic: topic
    end
  end

  def load_select_search_type
    if action_name.eql?("show") || controller_name.eql?("favorites")
      Topic.pluck :name, :id
    elsif action_name.eql? "index"
      [
        [t(".created_time"), :created_at],
        [t(".alphabet"), :alphabet],
        [t(".followers"), :followers]
      ]
    end
  end

  def load_select_search_status
    if action_name.eql?("show") || controller_name.eql?("favorites")
      Post.statuses.keys.map do |key|
        [t(key.to_s), key]
      end
    elsif action_name.eql? "index"
      [[t(".follow"), :on], [t(".unfollow"), :off]]
    end
  end

  def display_post_pending_status post_status
    return unless post_status == "pending"

    button_tag t(".pending"), type: "button", class: "btn btn-warning mb-3"
  end

  def custom_bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      type = FLASH_TYPES[type.to_sym]
      text = javascript_tag "toastr.#{type}('#{message}');"
      flash_messages << text if message
    end
    safe_join flash_messages, "\n"
  end

  def load_report_contents post_id
    html = []
    ReportReason.all.each do |item|
      temp = content_tag :div, class: "form-check" do
        radio_button_tag(:report_reason_id, item.id, false,
                         class: "form-check-input",
                         id: "report-content-#{post_id}-#{item.id}") +
          label_tag("report-content-#{post_id}-#{item.id}", t(".#{item.name}"),
                    class: "form-check-label",
                    id: "report-label-#{post_id}-#{item.id}")
      end
      html << temp
    end
    safe_join html
  end
end
