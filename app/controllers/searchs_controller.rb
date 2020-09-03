class SearchsController < ApplicationController
  before_action :logged_in_user

  def index
    if params[:query_type].present?
      clazz = Object.const_get(params[:query_type])
      @datas = clazz.search params[:query]
    else
      @datas = []
    end
  end
end
