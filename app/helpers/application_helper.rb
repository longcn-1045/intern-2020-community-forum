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
end
