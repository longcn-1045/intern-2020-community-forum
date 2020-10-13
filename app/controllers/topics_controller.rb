class TopicsController < ApplicationController
  before_action :find_topic, only: :show

  authorize_resource Topic

  def index
    @topics = Topic.by_topic_name(params[:name])
                   .sort_type(params[:select_type])
                   .by_follow_status(params[:status], current_user)
                   .page(params[:page])
                   .per Settings.topics.per_page
  end

  def show
    @posts = @topic.posts
                   .on
                   .includes(:user, :tags, :post_marks)
                   .order_created_at
  end

  private

  def find_topic
    @topic = Topic.find_by id: params[:id]
    return if @topic

    flash[:alert] = t ".not_found"
    redirect_to root_url
  end
end
