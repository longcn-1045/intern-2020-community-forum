class FollowingsController < ApplicationController
  before_action :authenticate_user!, :find_user, :correct_user, only: :index

  def index; end
end
