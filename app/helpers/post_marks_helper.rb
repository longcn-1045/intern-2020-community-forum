module PostMarksHelper
  def save
    current_user.post_marks.build
  end

  def unsave post
    current_user.post_marks.find_by post_id: post.id
  end
end
