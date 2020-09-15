class TopicsController < ApplicationController
  before_action :find_topic, only: :show

  def index
    @topics = Topic.page(params[:page]).per Settings.topics.per_page
  end

  def show
    @posts = @topic.posts
                   .includes(:user, :tags, :post_marks)
                   .order_created_at
  end

  private

  def find_topic
    @topic = Topic.find_by id: params[:id]
    return if @topic

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end
end
