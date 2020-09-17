class UserTopicsController < ApplicationController
  before_action :logged_in_user
  before_action :find_topic, only: %i(create destroy)

  def create
    if @topic.present?
      if current_user.follow_topic? @topic
        @error = t ".followed topic"
      else
        current_user.follow_topic @topic
        record_activity "You have followed topic #{@topic.name}"
      end
    end

    respond_to :js
  end

  def destroy
    if @topic.present?
      if current_user.follow_topic? @topic
        current_user.unfollow_topic @topic
        record_activity "You have unfollowed topic #{@topic.name}"
      else
        @error = t ".unfollowed topic"
      end
    end

    respond_to :js
  end

  private

  def find_topic
    @topic = Topic.find_by id: params[:topic_id]
    return if @topic

    @error = t ".not_found"
  end
end
