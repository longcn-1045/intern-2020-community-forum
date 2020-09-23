class Admin::CheckPostsController < AdminController
  include PostsHelper

  def update
    @posts = Post.includes(:user, :topic).by_ids params[:post_ids]
    @posts.update_all status: params[:commit].downcase

    redirect_to admin_posts_path
  end
end
