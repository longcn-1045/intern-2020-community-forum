class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  authorize_resource Post

  def home
    @posts = Post.includes(Post::POST_INCLUDES)
                 .in_homepage(current_user).sort_by(&:post_score).reverse!

    @posts = Kaminari.paginate_array(@posts)
                     .page(params[:page]).per Settings.posts.per_page
  end

  def help; end

  def about; end

  def contact; end
end
