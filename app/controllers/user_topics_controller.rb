class UserTopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_topic, only: %i(create destroy)

  def create
    current_user.follow_topic @topic
    check_follow_topic

    respond_to :js
  end

  def destroy
    current_user.unfollow_topic @topic
    check_unfollow_topic

    respond_to :js
  end

  private

  def find_topic
    @topic = Topic.find_by id: params[:topic_id]
    return if @topic

    @error = t ".not_found"
  end

  def check_follow_topic
    @error = t ".unfollowed" unless current_user.follow_topic? @topic
  end

  def check_unfollow_topic
    @error = t ".followed" if current_user.follow_topic? @topic
  end
end
