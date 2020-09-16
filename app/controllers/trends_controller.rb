class TrendsController < ApplicationController
  def index
    @topics = Topic.order_by_user.first Settings.trends.topics

    @users = User.all_except(current_user)
                 .count_celeb
                 .first Settings.trends.celebrities
  end
end
