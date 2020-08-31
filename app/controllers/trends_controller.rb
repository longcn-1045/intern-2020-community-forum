class TrendsController < ApplicationController
  def index
    @topics = Topic.first(6)
    @users = User.first(3)
  end
end
