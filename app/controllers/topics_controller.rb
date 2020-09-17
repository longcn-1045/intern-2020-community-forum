class TopicsController < ApplicationController
  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find_by id: params[:id]
    return if @topic

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end
end
