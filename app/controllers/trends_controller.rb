class TrendsController < ApplicationController
  def index
    @topics = Topic.order_by_user.first Settings.trends.topics

    @users = User.all_except(current_user)
                 .order_followers_count
                 .first Settings.trends.celebrities
  end
end
