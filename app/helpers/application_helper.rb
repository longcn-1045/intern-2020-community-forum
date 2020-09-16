module ApplicationHelper
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

    error = object.errors
                  .full_messages[object.errors
                                       .messages.keys.index object_attr].to_s
    content_tag :div, error, class: Settings.default_user.error_class
  end
end
