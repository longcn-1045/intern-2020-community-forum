class FollowingsController < ApplicationController
  authorize_resource Relationship
  before_action :authenticate_user!, :find_user, :correct_user, only: :index

  def index; end
end
