class FavoritesController < ApplicationController
  authorize_resource Post

  before_action :authenticate_user!, :find_user, :correct_user, only: :index

  def index
    @posts = current_user.mark_posts
                         .order_mark_posts
                         .includes(:user, :topic, :tags)
                         .by_title(params[:name])
                         .by_topic_id(params[:select_type])
                         .by_status params[:status]
  end
end
