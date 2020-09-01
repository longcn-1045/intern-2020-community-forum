class FavoritesController < ApplicationController
  def index
    @posts = current_user.mark_posts
  end
end
