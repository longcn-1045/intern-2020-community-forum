class FavoritesController < ApplicationController
  before_action :logged_in_user

  def index
    @posts = current_user.mark_posts.includes(:user, :topic, :tags).order_mark_posts
  end
end
