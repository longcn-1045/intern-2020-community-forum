class Admin::GetReportsController < AdminController
  before_action :get_posts

  def index
    @reports = @post.post_reports.includes(:user).order_updated_at
    respond_to :js
  end

  private

  def get_posts
    @post = Post.find_by id: params[:post_id]
    return if @post

    flash[:alert] = t "posts.controller.not_found"
    redirect_to admin_root_path
  end
end
