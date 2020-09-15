module PostLikesHelper
  def build_post_likes
    current_user.post_likes.build
  end

  def find_post_likes post
    current_user.post_likes.find_by post_id: post.id
  end
end
