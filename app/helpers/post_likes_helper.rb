module PostLikesHelper
  def like
    current_user.post_likes.build
  end

  def unlike post
    current_user.post_likes.find_by post_id: post.id
  end
end
