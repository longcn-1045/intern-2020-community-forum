class PostReportsController < ApplicationController
  authorize_resource

  before_action :authenticate_user!
  before_action :find_post, :check_reported_post, only: :create

  def create
    if flash.blank?
      @report = current_user.post_reports.build post_report_params
      if @report.save
        flash.now[:notice] = t ".report_created"
      else
        flash.now[:alert] = t ".report_create_failed"
      end
    end
    respond_to :js
  end

  private

  def find_post
    @post = Post.find_by id: params[:post_id]
    return if @post

    flash.now[:alert] = t ".not_found"
  end

  def post_report_params
    params.permit PostReport::PERMIT_ATTRIBUTES
  end

  def check_reported_post
    flash.now[:alert] = t ".reported_post" if current_user.report_post? @post
  end
end
