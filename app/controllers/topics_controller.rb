class TopicsController < ApplicationController
  def index
    @topics = Topic.page(params[:page]).per Settings.topics.per_page
  end

  def show
    @topic = Topic.find_by id: params[:id]
    return if @topic

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end
end
