module PostMarksHelper
  def build_post_marks
    current_user.post_marks.build
  end

  def find_post_marks post
    current_user.post_marks.find_by post_id: post.id
  end
end
