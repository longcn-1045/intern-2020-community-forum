class Admin::ChartsController < AdminController
  def post_new
    render json: Post.group_by_day(:created_at).count
  end

  def user_new
    render json: User.group_by_day(:created_at).count
  end

  def user_post
    render json: User.joins(:posts).group("users.name").count
  end
end
