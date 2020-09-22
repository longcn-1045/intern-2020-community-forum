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

  def load_select_search_sort_by
    [[t(".created_time"), :created_at],
     [t(".alphabet"), :alphabet],
     [t(".followers"), :followers]]
  end

  def load_select_search_status
    [[t(".follow"), :on], [t(".unfollow"), :off]]
  end
end
