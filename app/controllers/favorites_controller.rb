class FavoritesController < ApplicationController
  before_action :logged_in_user

  def index
    @posts = current_user.mark_posts.order_mark_posts
  end
end
