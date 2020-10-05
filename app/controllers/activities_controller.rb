class ActivitiesController < ApplicationController
  before_action :authenticate_user!, :find_user, :correct_user, only: :index

  def index
    @activities = @user.activities
                       .includes(:owner, :trackable)
                       .order_created_at
                       .page(params[:page])
                       .per Settings.activities.per_page
  end
end
