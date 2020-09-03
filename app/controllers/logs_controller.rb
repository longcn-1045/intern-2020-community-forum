class LogsController < ApplicationController
  before_action :logged_in_user

  def index
    @logs = Log.all
  end
end
